//  AddMealsToGroceriesSheet.swift
//  CookGPT
//
//  Sheet to review and fine-tune scheduled meals before adding to groceries.
//

import SwiftUI
import SwiftData

struct AddMealsToGroceriesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppNavigationStore.self) private var navigation

    let meals: [ScheduledMeal]
    let recipes: [Recipe]
    let startDate: Date
    let endDate: Date
    let includedMealSlots: Set<MealSlot>
    let onAdd: (_ meals: [ScheduledMeal], _ startDate: Date, _ endDate: Date) -> Void

    @State private var selectedStartDate: Date
    @State private var selectedEndDate: Date
    @State private var includeBreakfast: Bool
    @State private var includeLunch: Bool
    @State private var includeDinner: Bool

    init(
        meals: [ScheduledMeal],
        recipes: [Recipe],
        startDate: Date,
        endDate: Date,
        includedMealSlots: Set<MealSlot>,
        onAdd: @escaping (_ meals: [ScheduledMeal], _ startDate: Date, _ endDate: Date) -> Void
    ) {
        self.meals = meals
        self.recipes = recipes
        self.startDate = startDate
        self.endDate = endDate
        self.includedMealSlots = includedMealSlots
        self.onAdd = onAdd
        _selectedStartDate = State(initialValue: MealScheduleCalendar.startOfDay(startDate))
        _selectedEndDate = State(initialValue: MealScheduleCalendar.startOfDay(endDate))
        _includeBreakfast = State(initialValue: includedMealSlots.contains(.breakfast))
        _includeLunch = State(initialValue: includedMealSlots.contains(.lunch))
        _includeDinner = State(initialValue: includedMealSlots.contains(.dinner))
    }

    private var selectedMealSlotSet: Set<MealSlot> {
        var slots = Set<MealSlot>()
        if includeBreakfast { slots.insert(.breakfast) }
        if includeLunch { slots.insert(.lunch) }
        if includeDinner { slots.insert(.dinner) }
        return slots
    }

    private var recipeTitlesByID: [UUID: String] {
        Dictionary(uniqueKeysWithValues: recipes.map { ($0.id, $0.title) })
    }

    private var filteredMeals: [ScheduledMeal] {
        ShoppingListGenerator.meals(
            from: meals,
            allRecipes: recipes,
            navigation: navigation,
            startDate: selectedStartDate,
            endDate: selectedEndDate,
            mealSlots: selectedMealSlotSet
        )
    }

    private var previewDays: [Date] {
        MealScheduleCalendar.dates(from: selectedStartDate, through: selectedEndDate)
    }

    private var canAdd: Bool {
        !selectedMealSlotSet.isEmpty && !filteredMeals.isEmpty
    }

    private var rangeSummary: String {
        let start = selectedStartDate.formatted(date: .abbreviated, time: .omitted)
        let end = selectedEndDate.formatted(date: .abbreviated, time: .omitted)
        if MealScheduleCalendar.isSameDay(selectedStartDate, selectedEndDate) {
            return start
        }
        return "\(start) – \(end)"
    }

    private var breakfastBinding: Binding<Bool> {
        Binding(
            get: { includeBreakfast },
            set: { setIncludeMealSlot(.breakfast, isOn: $0) }
        )
    }

    private var lunchBinding: Binding<Bool> {
        Binding(
            get: { includeLunch },
            set: { setIncludeMealSlot(.lunch, isOn: $0) }
        )
    }

    private var dinnerBinding: Binding<Bool> {
        Binding(
            get: { includeDinner },
            set: { setIncludeMealSlot(.dinner, isOn: $0) }
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Range") {
                    DatePicker("Start", selection: $selectedStartDate, displayedComponents: .date)
                    DatePicker("End", selection: $selectedEndDate, displayedComponents: .date)
                    Text(rangeSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Meals") {
                    mealSlotToggleRow(slot: .breakfast, isOn: breakfastBinding)
                    mealSlotToggleRow(slot: .lunch, isOn: lunchBinding)
                    mealSlotToggleRow(slot: .dinner, isOn: dinnerBinding)
                }

                Section {
                    if filteredMeals.isEmpty {
                        Text("No scheduled meals match this range and meal selection.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(previewDays, id: \.self) { day in
                            let dayMeals = filteredMeals
                                .filter { MealScheduleCalendar.isSameDay($0.day, day) }
                                .sortedByMealSlot(using: navigation)

                            if !dayMeals.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(MealScheduleCalendar.dayTitle(day))
                                        .font(.subheadline.weight(.semibold))

                                    ForEach(dayMeals, id: \.persistentModelID) { meal in
                                        if let recipeID = meal.recipeID,
                                           let title = recipeTitlesByID[recipeID] {
                                            HStack {
                                                Text(navigation.mealSlotLabel(for: meal.id))
                                                    .font(.caption.weight(.semibold))
                                                    .foregroundStyle(.secondary)
                                                    .frame(width: 72, alignment: .leading)
                                                Text(title)
                                                Spacer(minLength: 0)
                                                Text("\(meal.servings)")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                } header: {
                    Text("Selected meals")
                } footer: {
                    if canAdd {
                        Text("\(filteredMeals.count) meal\(filteredMeals.count == 1 ? "" : "s") will be added to your shopping list.")
                    }
                }
            }
            .navigationTitle("Add to shopping list")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel(String(localized: "Cancel"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onAdd(filteredMeals, selectedStartDate, selectedEndDate)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .fontWeight(.semibold)
                    }
                    .disabled(!canAdd)
                    .accessibilityLabel("Add to shopping list")
                }
            }
            .onAppear {
                applyMealSlotAvailability()
            }
            .onChange(of: selectedStartDate) { _, newValue in
                let normalized = MealScheduleCalendar.startOfDay(newValue)
                if normalized != newValue {
                    selectedStartDate = normalized
                    return
                }
                if selectedEndDate < normalized {
                    selectedEndDate = normalized
                }
                applyMealSlotAvailability()
            }
            .onChange(of: selectedEndDate) { _, newValue in
                let normalized = MealScheduleCalendar.startOfDay(newValue)
                if normalized != newValue {
                    selectedEndDate = normalized
                    return
                }
                if normalized < selectedStartDate {
                    selectedStartDate = normalized
                }
                applyMealSlotAvailability()
            }
        }
    }

    @ViewBuilder
    private func mealSlotToggleRow(slot: MealSlot, isOn: Binding<Bool>) -> some View {
        let isAvailable = hasMeals(for: slot)

        HStack(spacing: 12) {
            if !isAvailable {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .accessibilityLabel("No \(slot.label) meals in this range")
            }

            Toggle(slot.label, isOn: isOn)
                .disabled(!isAvailable)
        }
    }

    private func hasMeals(for slot: MealSlot) -> Bool {
        !ShoppingListGenerator.meals(
            from: meals,
            allRecipes: recipes,
            navigation: navigation,
            startDate: selectedStartDate,
            endDate: selectedEndDate,
            mealSlots: [slot]
        ).isEmpty
    }

    private func setIncludeMealSlot(_ slot: MealSlot, isOn: Bool) {
        guard hasMeals(for: slot) else {
            switch slot {
            case .breakfast: includeBreakfast = false
            case .lunch: includeLunch = false
            case .dinner: includeDinner = false
            }
            return
        }

        switch slot {
        case .breakfast: includeBreakfast = isOn
        case .lunch: includeLunch = isOn
        case .dinner: includeDinner = isOn
        }
    }

    private func applyMealSlotAvailability() {
        if !hasMeals(for: .breakfast) { includeBreakfast = false }
        if !hasMeals(for: .lunch) { includeLunch = false }
        if !hasMeals(for: .dinner) { includeDinner = false }
    }
}
