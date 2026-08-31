//  ScheduleMealSheet.swift
//  CookGPT
//
//  Sheet to add or edit one scheduled meal.
//

import SwiftUI
import SwiftData

struct ScheduleMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @Query(sort: \Recipe.title) private var recipes: [Recipe]

    var existingMeal: ScheduledMeal?
    var defaultDate: Date

    @State private var day: Date
    @State private var mealSlot: MealSlot = .lunch
    @State private var selectedRecipeID: UUID?
    @State private var servings = 2

    init(existingMeal: ScheduledMeal? = nil, defaultDate: Date = .now) {
        self.existingMeal = existingMeal
        self.defaultDate = defaultDate
        _day = State(initialValue: existingMeal?.day ?? MealScheduleCalendar.startOfDay(defaultDate))
        _mealSlot = State(initialValue: existingMeal?.mealSlot ?? .lunch)
        _selectedRecipeID = State(initialValue: existingMeal?.recipeID)
        _servings = State(initialValue: existingMeal?.servings ?? AppSettingsStore.shared.defaultPlannerServings)
    }

    private var selectableMealSlots: [MealSlot] {
        MealSlot.allCases
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Day", selection: $day, displayedComponents: .date)

                Picker("Meal", selection: $mealSlot) {
                    ForEach(selectableMealSlots, id: \.self) { slot in
                        Text(slot.label).tag(slot)
                    }
                }

                Picker("Recipe", selection: $selectedRecipeID) {
                    Text("None").tag(UUID?.none)
                    ForEach(recipes) { recipe in
                        Text(recipe.title).tag(Optional(recipe.id))
                    }
                }

                Stepper("Servings: \(servings)", value: $servings, in: 1...12)
            }
            .navigationTitle(existingMeal == nil ? "Schedule meal" : "Edit meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(selectedRecipeID == nil)
                }
            }
            .onAppear {
                clampMealSlotIfNeeded()
            }
        }
    }

    private func clampMealSlotIfNeeded() {
        guard existingMeal == nil else { return }
        if !selectableMealSlots.contains(mealSlot) {
            mealSlot = selectableMealSlots.first ?? .lunch
        }
    }

    private func save() {
        guard let recipe = recipes.first(where: { $0.id == selectedRecipeID }) else { return }

        if let existingMeal {
            existingMeal.day = MealScheduleCalendar.startOfDay(day)
            existingMeal.mealSlot = mealSlot
            existingMeal.recipe = recipe
            existingMeal.recipeID = recipe.id
            existingMeal.servings = servings
        } else {
            let meal = ScheduledMeal(
                day: day,
                mealSlot: mealSlot,
                recipe: recipe,
                servings: servings
            )
            modelContext.insert(meal)
        }

        try? modelContext.save()
        dismiss()
    }
}
