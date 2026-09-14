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
    @State private var selectedDietType: DietType
    @State private var includeBreakfast = false
    @State private var includeLunch = true
    @State private var includeDinner = true
    @State private var showBreakfastUnavailableAlert = false

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
        _selectedStartDate = State(initialValue: MealScheduleCalendar.startOfDay(startDate))
        _selectedNumberOfDays = State(initialValue: numberOfDays)
        _servings = State(initialValue: initialServings ?? AppSettingsStore.shared.defaultPlannerServings)
        _selectedDietType = State(initialValue: profile.dietType)
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

    private var availableDietTypes: [DietType] {
        MealPlanner.availableDietTypes(from: recipes, for: selectedMealSlots)
    }

    private var eligibleRecipesDescription: String {
        selectedMealSlots.map { slot in
            let count = MealPlanner.eligibleRecipes(
                dietType: selectedDietType,
                from: recipes,
                for: slot
            ).count
            return "\(slot.label): \(count)"
        }
        .joined(separator: " · ")
    }

    private var canEnableBreakfastPlanning: Bool {
        !MealPlanner.eligibleRecipes(
            dietType: selectedDietType,
            from: recipes,
            for: .breakfast
        ).isEmpty
    }

    private var requiresExclusiveLunchOrDinner: Bool {
        MealPlanner.requiresExclusiveLunchOrDinner(
            dietType: selectedDietType,
            from: recipes
        )
    }

    private var canPlan: Bool {
        MealPlanner.canPlanMeals(
            dietType: selectedDietType,
            from: recipes,
            for: selectedMealSlots
        )
    }

    private var lunchBinding: Binding<Bool> {
        Binding(
            get: { includeLunch },
            set: { setIncludeLunch($0) }
        )
    }

    private var dinnerBinding: Binding<Bool> {
        Binding(
            get: { includeDinner },
            set: { setIncludeDinner($0) }
        )
    }

    private var breakfastBinding: Binding<Bool> {
        Binding(
            get: { includeBreakfast },
            set: { setIncludeBreakfast($0) }
        )
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
                    Picker("Type", selection: $selectedDietType) {
                        ForEach(availableDietTypes, id: \.self) { dietType in
                            Text(dietType.label).tag(dietType)
                        }
                    }
                    Text("Rated recipes are prioritized using a mix of star rating and difficulty. Recipes are matched to your diet type. More diet types appear when at least one category has two or more matching recipes. Breakfast recipes are used only for breakfast. Dessert recipes are excluded.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section {
                    breakfastToggleRow
                    Toggle("Lunch", isOn: lunchBinding)
                    Toggle("Dinner", isOn: dinnerBinding)
                } footer: {
                    if requiresExclusiveLunchOrDinner {
                        Text("Only one lunch or dinner recipe is available for this diet type, so choose lunch or dinner.")
                    } else {
                        Text("Choose which meals to plan each day. Breakfast uses only recipes tagged Breakfast. Lunch and dinner never use breakfast recipes. Lunch and dinner on the same day always use different recipes when possible.")
                    }
                }

                Section("Schedule") {
                    DatePicker("Start", selection: $selectedStartDate, displayedComponents: .date)
                    Stepper(
                        String(format: String(localized: "Days: %lld"), selectedNumberOfDays),
                        value: $selectedNumberOfDays,
                        in: 1...31
                    )
                    Stepper(
                        String(format: String(localized: "Servings per meal: %lld"), servings),
                        value: $servings,
                        in: 1...12
                    )
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
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                    }
                    .accessibilityLabel("Back")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        plan()
                    } label: {
                        Image(systemName: "checkmark")
                            .fontWeight(.semibold)
                    }
                    .disabled(!canPlan)
                    .accessibilityLabel("Plan meals")
                }
            }
            .onAppear {
                if let initialServings {
                    servings = initialServings
                } else {
                    servings = settings.defaultPlannerServings
                }
                syncSelectedDietType()
                applyMealSlotConstraints()
            }
            .onChange(of: selectedDietType) { _, _ in
                syncSelectedDietType()
                applyMealSlotConstraints()
            }
            .onChange(of: includeBreakfast) { _, _ in syncSelectedDietType() }
            .onChange(of: includeLunch) { _, _ in syncSelectedDietType() }
            .onChange(of: includeDinner) { _, _ in syncSelectedDietType() }
            .alert(
                "Breakfast planning unavailable",
                isPresented: $showBreakfastUnavailableAlert
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Add at least one recipe to breakfast category to allow breakfast planning")
            }
        }
    }

    @ViewBuilder
    private var breakfastToggleRow: some View {
        HStack(spacing: 12) {
            if !canEnableBreakfastPlanning {
                Button {
                    showBreakfastUnavailableAlert = true
                } label: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Breakfast planning unavailable")
            }

            Toggle("Breakfast", isOn: breakfastBinding)
        }
    }

    private func setIncludeBreakfast(_ isOn: Bool) {
        if isOn && !canEnableBreakfastPlanning {
            showBreakfastUnavailableAlert = true
            includeBreakfast = false
            return
        }

        includeBreakfast = isOn
    }

    private func setIncludeLunch(_ isOn: Bool) {
        if requiresExclusiveLunchOrDinner {
            if isOn {
                includeLunch = true
                includeDinner = false
            } else if includeDinner {
                includeLunch = false
            } else {
                includeLunch = true
            }
            return
        }

        includeLunch = isOn
    }

    private func setIncludeDinner(_ isOn: Bool) {
        if requiresExclusiveLunchOrDinner {
            if isOn {
                includeDinner = true
                includeLunch = false
            } else if includeLunch {
                includeDinner = false
            } else {
                includeDinner = true
            }
            return
        }

        includeDinner = isOn
    }

    private func applyMealSlotConstraints() {
        if !canEnableBreakfastPlanning {
            includeBreakfast = false
        }

        guard requiresExclusiveLunchOrDinner else { return }

        if includeLunch && includeDinner {
            includeDinner = false
        } else if !includeLunch && !includeDinner {
            includeLunch = true
        }
    }

    private func syncSelectedDietType() {
        let available = availableDietTypes
        guard !available.isEmpty else { return }

        if available.contains(selectedDietType) {
            return
        }

        if available.contains(profile.dietType) {
            selectedDietType = profile.dietType
        } else {
            selectedDietType = available[0]
        }
    }

    private func plan() {
        onPlan(
            MealPlanRequest(
                startDate: selectedStartDate,
                numberOfDays: selectedNumberOfDays,
                servings: servings,
                dietType: selectedDietType,
                mealSlots: selectedMealSlots
            )
        )
        dismiss()
    }
}
