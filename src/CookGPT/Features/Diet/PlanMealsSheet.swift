//  PlanMealsSheet.swift
//  CookGPT
//
//  Sheet to auto-fill meals across a date range.
//

import SwiftUI
import SwiftData

struct PlanMealsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettingsStore.self) private var settings

    let profile: DietProfile
    let startDate: Date
    let numberOfDays: Int
    let includedMealSlots: Set<MealSlot>
    let initialServings: Int?
    let onPlan: (MealPlanRequest) -> Void

    @Query(sort: \Recipe.title) private var recipes: [Recipe]

    @State private var selectedStartDate: Date
    @State private var selectedNumberOfDays: Int
    @State private var servings = 1
    @State private var includeBreakfast = false
    @State private var includeLunch = true
    @State private var includeDinner = true

    init(
        profile: DietProfile,
        startDate: Date,
        numberOfDays: Int,
        includedMealSlots: Set<MealSlot> = [.lunch, .dinner],
        initialServings: Int? = nil,
        onPlan: @escaping (MealPlanRequest) -> Void
    ) {
        self.profile = profile
        self.startDate = startDate
        self.numberOfDays = numberOfDays
        self.includedMealSlots = includedMealSlots
        self.initialServings = initialServings
        self.onPlan = onPlan
        _selectedStartDate = State(initialValue: startDate)
        _selectedNumberOfDays = State(initialValue: numberOfDays)
        _servings = State(initialValue: initialServings ?? AppSettingsStore.shared.defaultPlannerServings)
        _includeBreakfast = State(initialValue: includedMealSlots.contains(.breakfast))
        _includeLunch = State(initialValue: includedMealSlots.contains(.lunch))
        _includeDinner = State(initialValue: includedMealSlots.contains(.dinner))
    }

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

    private var eligibleRecipesDescription: String {
        selectedMealSlots.map { slot in
            let count = MealPlanner.eligibleRecipes(
                dietType: profile.dietType,
                from: recipes,
                for: slot
            ).count
            return "\(slot.label): \(count)"
        }
        .joined(separator: " · ")
    }

    private var canPlan: Bool {
        !selectedMealSlots.isEmpty && selectedMealSlots.allSatisfy { slot in
            !MealPlanner.eligibleRecipes(
                dietType: profile.dietType,
                from: recipes,
                for: slot
            ).isEmpty
        }
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
                    Text("Favorites are prioritized. Recipes are matched to your diet type. Breakfast recipes are used only for breakfast. Dessert recipes are excluded.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Toggle("Breakfast", isOn: $includeBreakfast)
                    Toggle("Lunch", isOn: $includeLunch)
                    Toggle("Dinner", isOn: $includeDinner)
                } footer: {
                    Text("Choose which meals to plan each day. Breakfast uses only recipes tagged Breakfast. Lunch and dinner never use breakfast recipes.")
                }

                Section("Schedule") {
                    DatePicker("Start", selection: $selectedStartDate, displayedComponents: .date)
                    Stepper("Days: \(selectedNumberOfDays)", value: $selectedNumberOfDays, in: 1...31)
                    Stepper("Servings per meal: \(servings)", value: $servings, in: 1...12)
                }

                Section {
                    Text(eligibleRecipesDescription)
                        .foregroundStyle(.secondary)
                    Text("\(plannedSlotsDescription) will be planned for each day. Existing meals for those slots in this range will be replaced.")
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
                        .disabled(!canPlan)
                }
            }
            .onAppear {
                if let initialServings {
                    servings = initialServings
                } else {
                    servings = settings.defaultPlannerServings
                }
            }
        }
    }

    private func plan() {
        onPlan(
            MealPlanRequest(
                startDate: selectedStartDate,
                numberOfDays: selectedNumberOfDays,
                servings: servings,
                dietType: profile.dietType,
                mealSlots: selectedMealSlots
            )
        )
        dismiss()
    }
}
