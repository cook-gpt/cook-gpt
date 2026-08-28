//  PlanMealsSheet.swift
//  CookGPT
//
//  Sheet to auto-fill meals across a date range.
//

import SwiftUI
import SwiftData

struct PlanMealsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    let profile: DietProfile

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]

    @State private var startDate = Date()
    @State private var numberOfDays = 7
    @State private var servings = 1
    @State private var includeBreakfast = false
    @State private var includeLunch = true
    @State private var includeDinner = true

    private var selectedMealSlots: [MealSlot] {
        MealSlot.plannerSlots(included: selectedMealSlotSet)
    }

    private var selectedMealSlotSet: Set<MealSlot> {
        var slots = Set<MealSlot>()
        if includeBreakfast { slots.insert(.breakfast) }
        if includeLunch { slots.insert(.lunch) }
        if includeDinner { slots.insert(.dinner) }
        return slots
    }

    private var eligibleCount: Int {
        MealPlanner.eligibleRecipes(dietType: profile.dietType, from: recipes).count
    }

    private var plannedSlotsDescription: String {
        let labels = selectedMealSlots.map(\.label)
        guard !labels.isEmpty else { return "No meals" }
        if labels.count == 1 { return labels[0] }
        if labels.count == 2 { return "\(labels[0]) and \(labels[1])" }
        return "\(labels.dropLast().joined(separator: ", ")), and \(labels[labels.count - 1])"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Diet") {
                    LabeledContent("Type", value: profile.dietType.label)
                    Text("Favorites are prioritized. Recipes are matched to your diet type. Breakfast and dessert recipes are excluded.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Toggle("Breakfast", isOn: $includeBreakfast)
                    Toggle("Lunch", isOn: $includeLunch)
                    Toggle("Dinner", isOn: $includeDinner)
                } footer: {
                    Text("Choose which meals to plan each day. Breakfast and dessert recipes are never used by the planner.")
                }

                Section("Schedule") {
                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                    Stepper("Days: \(numberOfDays)", value: $numberOfDays, in: 1...31)
                    Stepper("Servings per meal: \(servings)", value: $servings, in: 1...12)
                }

                Section {
                    Text("\(eligibleCount) recipes match this diet for meal planning.")
                        .foregroundStyle(.secondary)
                    Text("\(plannedSlotsDescription) will be planned for each day. Existing meals in this range will be replaced.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Plan your meals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Plan") { plan() }
                        .disabled(eligibleCount == 0 || selectedMealSlots.isEmpty)
                }
            }
            .onAppear {
                servings = settings.defaultPlannerServings
            }
        }
    }

    private func plan() {
        MealPlanner.planMeals(
            startingAt: startDate,
            numberOfDays: numberOfDays,
            servings: servings,
            dietType: profile.dietType,
            mealSlots: selectedMealSlots,
            recipes: recipes,
            existingMeals: scheduledMeals,
            context: modelContext
        )
        dismiss()
    }
}
