import SwiftUI
import SwiftData

struct GenerateShoppingListSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]

    let list: GroceryList
    var onGenerated: () -> Void

    @State private var scope: ShoppingListScope = .week
    @State private var customStart = Date()
    @State private var customEnd = Date()
    @State private var useScheduledMeals = true
    @State private var selectedRecipeIDs: Set<UUID> = []

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

    var body: some View {
        NavigationStack {
            Form {
                Section("Source") {
                    Picker("Generate from", selection: $useScheduledMeals) {
                        Text("Scheduled meals").tag(true)
                        Text("Selected recipes").tag(false)
                    }
                    .pickerStyle(.segmented)
                }

                if useScheduledMeals {
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
                } else {
                    Section("Recipes") {
                        if recipes.isEmpty {
                            Text("No recipes available.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(recipes) { recipe in
                                Toggle(isOn: binding(for: recipe.id)) {
                                    Text(recipe.title)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Generate list")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Generate") { generate() }
                        .disabled(!canGenerate)
                }
            }
        }
    }

    private var canGenerate: Bool {
        if useScheduledMeals {
            return !mealsInRange.isEmpty
        }
        return !selectedRecipeIDs.isEmpty
    }

    private func binding(for recipeID: UUID) -> Binding<Bool> {
        Binding(
            get: { selectedRecipeIDs.contains(recipeID) },
            set: { isOn in
                if isOn {
                    selectedRecipeIDs.insert(recipeID)
                } else {
                    selectedRecipeIDs.remove(recipeID)
                }
            }
        )
    }

    private func generate() {
        let recipeEntries: [(recipe: Recipe, servings: Int)]
        let sourceDescription: String

        if useScheduledMeals {
            recipeEntries = ShoppingListGenerator.recipes(from: mealsInRange)
            let (start, end) = range
            sourceDescription = ShoppingListGenerator.sourceLabel(for: scope, start: start, end: end)
        } else {
            recipeEntries = recipes
                .filter { selectedRecipeIDs.contains($0.id) }
                .map { ($0, $0.servings) }
            sourceDescription = ShoppingListGenerator.recipesLabel(count: recipeEntries.count)
        }

        let aggregated = ShoppingListGenerator.aggregate(recipes: recipeEntries)

        list.items.forEach { modelContext.delete($0) }
        list.items = []

        for item in aggregated {
            let groceryItem = GroceryItem(
                name: item.name,
                quantity: item.quantity,
                unit: item.unit,
                list: list
            )
            modelContext.insert(groceryItem)
            list.items.append(groceryItem)
        }

        list.sourceDescription = sourceDescription
        list.generatedAt = .now
        try? modelContext.save()
        onGenerated()
        dismiss()
    }
}
