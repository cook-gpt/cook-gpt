//  GenerateShoppingListSheet.swift
//  Cook GPT
//
//  Import groceries from schedule or a single recipe.
//

import SwiftUI
import SwiftData

enum GenerateShoppingListSource: Identifiable {
    case schedule
    case recipe

    var id: Self { self }

    var navigationTitle: String {
        switch self {
        case .schedule: "From schedule"
        case .recipe: "From recipe"
        }
    }
}

struct GenerateShoppingListSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]

    let list: GroceryList
    let source: GenerateShoppingListSource
    var onGenerated: () -> Void

    @State private var deletePreviousList = false
    @State private var scope: ShoppingListScope = .week
    @State private var customStart = Date()
    @State private var customEnd = Date()
    @State private var selectedRecipeID: UUID?
    @State private var servings = 2

    private var range: (start: Date, end: Date) {
        MealScheduleCalendar.dateRange(
            for: scope,
            referenceDate: .now,
            customStart: customStart,
            customEnd: customEnd
        )
    }

    private var mealsInRange: [ScheduledMeal] {
        let (start, end) = range
        return scheduledMeals.filter { meal in
            let day = MealScheduleCalendar.startOfDay(meal.day)
            return day >= start && day <= end
        }
    }

    private var selectedRecipe: Recipe? {
        guard let selectedRecipeID else { return nil }
        return recipes.first { $0.id == selectedRecipeID }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Delete previous list", isOn: $deletePreviousList)
                } footer: {
                    Text("When off, imported ingredients are added to your existing list.")
                }

                switch source {
                case .schedule:
                    Section("Schedule range") {
                        Picker("Range", selection: $scope) {
                            ForEach(ShoppingListScope.allCases) { option in
                                Text(option.label).tag(option)
                            }
                        }

                        if scope == .custom {
                            DatePicker("From", selection: $customStart, displayedComponents: .date)
                            DatePicker("To", selection: $customEnd, displayedComponents: .date)
                        }

                        Text("\(mealsInRange.count) scheduled meals in range")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                case .recipe:
                    Section {
                        if recipes.isEmpty {
                            Text("No recipes available.")
                                .foregroundStyle(.secondary)
                        } else {
                            Picker("Recipe", selection: $selectedRecipeID) {
                                ForEach(recipes) { recipe in
                                    Text(recipe.title).tag(Optional(recipe.id))
                                }
                            }

                            if selectedRecipe != nil {
                                Stepper("Servings: \(servings)", value: $servings, in: 1...24)
                            }
                        }
                    } footer: {
                        if let selectedRecipe {
                            Text("Recipe serves \(selectedRecipe.servings). Ingredient amounts scale to your selection.")
                        }
                    }
                }
            }
            .navigationTitle(source.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { addToList() }
                        .disabled(!canAdd)
                }
            }
            .onAppear {
                guard source == .recipe else { return }
                initializeRecipeSelection()
            }
            .onChange(of: selectedRecipeID) {
                syncServingsToSelectedRecipe()
            }
        }
    }

    private var canAdd: Bool {
        switch source {
        case .schedule:
            return !mealsInRange.isEmpty
        case .recipe:
            return selectedRecipe != nil
        }
    }

    private func initializeRecipeSelection() {
        guard selectedRecipeID == nil, let firstRecipe = recipes.first else { return }
        selectedRecipeID = firstRecipe.id
        servings = firstRecipe.servings
    }

    private func syncServingsToSelectedRecipe() {
        guard let selectedRecipe else { return }
        servings = selectedRecipe.servings
    }

    private func addToList() {
        let recipeEntries: [(recipe: Recipe, servings: Int)]
        let sourceDescription: String

        switch source {
        case .schedule:
            recipeEntries = ShoppingListGenerator.recipes(from: mealsInRange)
            let (start, end) = range
            sourceDescription = ShoppingListGenerator.sourceLabel(for: scope, start: start, end: end)
        case .recipe:
            guard let selectedRecipe else { return }
            recipeEntries = [(recipe: selectedRecipe, servings: servings)]
            sourceDescription = ShoppingListGenerator.recipesLabel(count: 1)
        }

        let imported = ShoppingListGenerator.aggregate(recipes: recipeEntries)
        let finalItems: [AggregatedGroceryItem]

        if deletePreviousList {
            finalItems = imported
        } else {
            finalItems = ShoppingListGenerator.merge(aggregated: imported, with: list.items)
        }

        list.items.forEach { modelContext.delete($0) }
        list.items = []

        for item in finalItems {
            let groceryItem = GroceryItem(
                name: item.name,
                quantity: item.quantity,
                unit: item.unit,
                isChecked: item.isChecked,
                list: list
            )
            modelContext.insert(groceryItem)
            list.items.append(groceryItem)
        }

        if deletePreviousList || list.sourceDescription.isEmpty {
            list.sourceDescription = sourceDescription
        } else {
            list.sourceDescription = "\(list.sourceDescription) + \(sourceDescription)"
        }
        list.generatedAt = .now
        try? modelContext.save()
        onGenerated()
        dismiss()
    }
}
