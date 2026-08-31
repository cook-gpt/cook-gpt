//  DietRootView.swift
//  CookGPT
//
//  Meals tab: day/week/month schedule browsing and meal management.
//

import SwiftUI
import SwiftData

private struct MealRecipeDetailRoute: Hashable {
    let recipeID: UUID
    let servings: Int
}

struct DietRootView: View {
    @Query(filter: #Predicate<DietProfile> { $0.isActive == true })
    private var activeProfiles: [DietProfile]

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @State private var viewMode: ScheduleViewMode = .week
    @State private var selectedDate = Date()
    @State private var isPlanningMeals = false
    @State private var planMealsStartDate = Date()
    @State private var planMealsNumberOfDays = 7
    @State private var planMealsIncludedSlots: Set<MealSlot> = [.lunch, .dinner]
    @State private var planMealsInitialServings: Int?
    @State private var isApplyingMealPlan = false
    @State private var isEditingMeals = false
    @State private var mealRecipePickerContext: MealRecipePickerContext?

    private var activeProfile: DietProfile? {
        activeProfiles.first
    }

    private var weekDays: [Date] {
        // Observe week-start preference so the week grid refreshes when it changes in Settings.
        let _ = settings.weekStart
        return MealScheduleCalendar.daysInWeek(containing: selectedDate)
    }

    private var visibleMeals: [ScheduledMeal] {
        switch viewMode {
        case .day:
            return scheduledMeals.filter { MealScheduleCalendar.isSameDay($0.day, selectedDate) }
        case .week:
            let days = Set(weekDays.map { MealScheduleCalendar.startOfDay($0) })
            return scheduledMeals.filter { days.contains(MealScheduleCalendar.startOfDay($0.day)) }
        case .month:
            let days = Set(
                MealScheduleCalendar.daysInMonth(containing: selectedDate).map {
                    MealScheduleCalendar.startOfDay($0)
                }
            )
            return scheduledMeals.filter { days.contains(MealScheduleCalendar.startOfDay($0.day)) }
        }
    }

    private var exportDays: [Date] {
        switch viewMode {
        case .day:
            return [MealScheduleCalendar.startOfDay(selectedDate)]
        case .week:
            return weekDays
        case .month:
            return MealScheduleCalendar.daysInMonth(containing: selectedDate)
        }
    }

    private var exportShareText: String {
        MealScheduleShareFormatter.text(
            days: exportDays,
            meals: visibleMeals,
            recipes: recipes
        )
    }

    private var hasExportableMeals: Bool {
        visibleMeals.contains { meal in
            guard let recipeID = meal.recipeID else { return false }
            return recipes.contains { $0.id == recipeID }
        }
    }

    var body: some View {
        Group {
            if settings.isResettingData {
                ProgressView("Resetting app data…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if activeProfile == nil {
                EmptyStateView(
                    systemImage: "calendar",
                    title: "No diet profile",
                    subtitle: "A diet profile is created on first launch."
                )
            } else if isApplyingMealPlan {
                ProgressView("Planning meals…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    Picker("View", selection: $viewMode) {
                        ForEach(ScheduleViewMode.allCases, id: \.self) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    periodHeader

                    Group {
                        switch viewMode {
                        case .day:
                            dayScheduleView
                        case .week:
                            weekScheduleView
                        case .month:
                            monthScheduleView
                        }
                    }
                }
            }
        }
        .navigationTitle("Meals")
        .navigationDestination(for: MealRecipeDetailRoute.self) { route in
            if let recipe = recipes.first(where: { $0.id == route.recipeID }) {
                RecipeDetailView(recipe: recipe, initialServings: route.servings)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                if activeProfile != nil && !isApplyingMealPlan && !isEditingMeals {
                    ShareLink(
                        item: exportShareText,
                        subject: Text("Scheduled meals")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(!hasExportableMeals)
                    .accessibilityLabel("Export scheduled meals")
                }
            }
            ToolbarItemGroup(placement: .primaryAction) {
                if activeProfile != nil && !isApplyingMealPlan {
                    if !isEditingMeals {
                        Button {
                            openPlanMeals()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("Plan meals")
                    }

                    Button {
                        if isEditingMeals {
                            finishEditingMeals()
                        } else {
                            isEditingMeals = true
                        }
                    } label: {
                        Image(systemName: isEditingMeals ? "checkmark" : "pencil")
                    }
                    .accessibilityLabel(isEditingMeals ? "Done editing" : "Edit meals")
                }
            }
        }
        .sheet(item: $mealRecipePickerContext) { context in
            NavigationStack {
                RecipeImportPickerContent(
                    recipes: recipes,
                    excludedRecipeIDs: [],
                    onSelect: { selectedRecipe in
                        if let meal = scheduledMeals.first(where: { $0.id == context.mealID }) {
                            meal.recipeID = selectedRecipe.id
                            meal.recipe = selectedRecipe
                        }
                        mealRecipePickerContext = nil
                    }
                )
                .navigationTitle("Select recipe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            mealRecipePickerContext = nil
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isPlanningMeals) {
            if let profile = activeProfile {
                PlanMealsSheet(
                    profile: profile,
                    startDate: planMealsStartDate,
                    numberOfDays: planMealsNumberOfDays,
                    includedMealSlots: planMealsIncludedSlots,
                    initialServings: planMealsInitialServings,
                    onPlan: applyMealPlan
                )
                .id(planMealsSheetID)
            }
        }
        .onChange(of: settings.isResettingData) { _, isResetting in
            if isResetting {
                isPlanningMeals = false
                isApplyingMealPlan = false
                isEditingMeals = false
                mealRecipePickerContext = nil
                planMealsInitialServings = nil
            }
        }
        .onAppear {
            ScheduledMeal.removeOrphanedMeals(
                validRecipeIDs: Set(recipes.map(\.id)),
                in: modelContext
            )
        }
    }

    private var planMealsSheetID: String {
        let slots = planMealsIncludedSlots.map(\.rawValue).sorted().joined(separator: "-")
        let servings = planMealsInitialServings.map(String.init) ?? "default"
        return "\(planMealsStartDate.timeIntervalSince1970)-\(planMealsNumberOfDays)-\(slots)-\(servings)"
    }

    private func applyMealPlan(_ request: MealPlanRequest) {
        isApplyingMealPlan = true

        Task { @MainActor in
            defer { isApplyingMealPlan = false }

            await Task.yield()

            let recipeDescriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.title)])
            let recipes = (try? modelContext.fetch(recipeDescriptor)) ?? []

            MealPlanner.planMeals(
                startingAt: request.startDate,
                numberOfDays: request.numberOfDays,
                servings: request.servings,
                dietType: request.dietType,
                mealSlots: request.mealSlots,
                recipes: recipes,
                context: modelContext
            )
        }
    }

    @ViewBuilder
    private var periodHeader: some View {
        HStack {
            Button {
                shiftPeriod(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(periodTitle)
                .font(.headline)

            Spacer()

            Button {
                shiftPeriod(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private var periodTitle: String {
        switch viewMode {
        case .day:
            return MealScheduleCalendar.dayTitle(selectedDate)
        case .week:
            return MealScheduleCalendar.weekRangeTitle(containing: selectedDate)
        case .month:
            return MealScheduleCalendar.monthTitle(for: selectedDate)
        }
    }

    @ViewBuilder
    private var dayScheduleView: some View {
        List {
            if let profile = activeProfile {
                Section("Diet") {
                    LabeledContent("Type", value: profile.dietType.label)
                }
            }

            ForEach(MealSlot.allCases, id: \.self) { slot in
                Section(slot.label) {
                    if isEditingMeals {
                        if let meal = meal(for: selectedDate, slot: slot) {
                            scheduledMealEditRow(meal, showsMealSlotLabel: false)
                        } else {
                            addMealRecipeRow(for: selectedDate, slot: slot)
                        }
                    } else if let meal = meal(for: selectedDate, slot: slot) {
                        scheduledMealListRow(meal, showsMealSlotLabel: false)
                    } else {
                        planMealSlotButton(for: slot)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var weekScheduleView: some View {
        List {
            ForEach(weekDays, id: \.self) { day in
                Section(MealScheduleCalendar.dayTitle(day)) {
                    if isEditingMeals {
                        ForEach(MealSlot.allCases, id: \.self) { slot in
                            if let meal = meal(for: day, slot: slot) {
                                scheduledMealEditRow(meal)
                            } else {
                                addMealRecipeRow(for: day, slot: slot, showsMealSlotLabel: true)
                            }
                        }
                    } else {
                        let dayMeals = meals(for: day)
                        if dayMeals.isEmpty {
                            planMealsButton(for: day)
                        } else {
                            ForEach(dayMeals, id: \.persistentModelID) { meal in
                                scheduledMealListRow(meal)
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var monthScheduleView: some View {
        List {
            ForEach(groupedMonthDays, id: \.day) { group in
                Section(MealScheduleCalendar.dayTitle(group.day)) {
                    if isEditingMeals {
                        ForEach(MealSlot.allCases, id: \.self) { slot in
                            if let meal = meal(for: group.day, slot: slot) {
                                scheduledMealEditRow(meal)
                            } else {
                                addMealRecipeRow(for: group.day, slot: slot, showsMealSlotLabel: true)
                            }
                        }
                    } else if group.meals.isEmpty {
                        planMealsButton(for: group.day)
                    } else {
                        ForEach(group.meals, id: \.persistentModelID) { meal in
                            scheduledMealListRow(meal)
                        }
                    }
                }
            }
        }
    }

    private var groupedMonthDays: [(day: Date, meals: [ScheduledMeal])] {
        MealScheduleCalendar.daysInMonth(containing: selectedDate).map { day in
            (day: day, meals: meals(for: day))
        }
    }

    private func meals(for day: Date) -> [ScheduledMeal] {
        scheduledMeals
            .filter { MealScheduleCalendar.isSameDay($0.day, day) }
            .sortedByMealSlot()
    }

    private func meal(for day: Date, slot: MealSlot) -> ScheduledMeal? {
        scheduledMeals.first {
            MealScheduleCalendar.isSameDay($0.day, day) && $0.mealSlot == slot
        }
    }

    private func addMeal(for day: Date, slot: MealSlot) {
        let meal = ScheduledMeal(
            day: day,
            mealSlot: slot,
            recipe: nil,
            servings: settings.defaultPlannerServings
        )
        modelContext.insert(meal)
        try? modelContext.save()
        mealRecipePickerContext = MealRecipePickerContext(mealID: meal.id)
    }

    @ViewBuilder
    private func addMealRecipeRow(
        for day: Date,
        slot: MealSlot,
        showsMealSlotLabel: Bool = false
    ) -> some View {
        Button {
            addMeal(for: day, slot: slot)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                if showsMealSlotLabel {
                    Text(slot.label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Text("+ Add recipe")
                    .foregroundStyle(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 12))
    }

    private func shiftPeriod(by value: Int) {
        let component: Calendar.Component
        switch viewMode {
        case .day: component = .day
        case .week: component = .weekOfYear
        case .month: component = .month
        }

        if let newDate = MealScheduleCalendar.calendar.date(byAdding: component, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }

    @ViewBuilder
    private func scheduledMealEditRow(_ meal: ScheduledMeal, showsMealSlotLabel: Bool = true) -> some View {
        ScheduledMealEditRow(
            meal: meal,
            recipes: recipes,
            showsMealSlotLabel: showsMealSlotLabel,
            onOpenPicker: { mealRecipePickerContext = MealRecipePickerContext(mealID: meal.id) },
            onDelete: { deleteMeal(meal) }
        )
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 12))
    }

    @ViewBuilder
    private func scheduledMealListRow(_ meal: ScheduledMeal, showsMealSlotLabel: Bool = true) -> some View {
        Group {
            if let recipe = recipe(for: meal) {
                NavigationLink(
                    value: MealRecipeDetailRoute(recipeID: recipe.id, servings: meal.servings)
                ) {
                    ScheduledMealRow(
                        meal: meal,
                        recipe: recipe,
                        showsMealSlotLabel: showsMealSlotLabel
                    )
                }
            } else {
                ScheduledMealRow(
                    meal: meal,
                    recipe: nil,
                    showsMealSlotLabel: showsMealSlotLabel
                )
            }
        }
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 12))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                deleteMeal(meal)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func recipe(for meal: ScheduledMeal) -> Recipe? {
        guard let recipeID = meal.recipeID else { return nil }
        return recipes.first { $0.id == recipeID }
    }

    private func deleteMeal(_ meal: ScheduledMeal) {
        modelContext.delete(meal)
        try? modelContext.save()
    }

    private func finishEditingMeals() {
        for meal in visibleMeals {
            meal.servings = min(max(meal.servings, 1), 24)

            if let recipeID = meal.recipeID,
               let recipe = recipes.first(where: { $0.id == recipeID }) {
                meal.recipe = recipe
            } else {
                modelContext.delete(meal)
            }
        }

        try? modelContext.save()
        isEditingMeals = false
    }

    private func openPlanMeals(
        for day: Date? = nil,
        mealSlots: Set<MealSlot>? = nil,
        servings: Int? = nil
    ) {
        let defaults = planMealsDefaults(for: day)
        planMealsStartDate = defaults.start
        planMealsNumberOfDays = defaults.days
        planMealsIncludedSlots = mealSlots ?? defaultPlanMealSlots
        planMealsInitialServings = servings
        isPlanningMeals = true
    }

    private var defaultPlanMealSlots: Set<MealSlot> {
        [.lunch, .dinner]
    }

    private func planMealsDefaults(for day: Date? = nil) -> (start: Date, days: Int) {
        if let day {
            return (MealScheduleCalendar.startOfDay(day), 1)
        }

        switch viewMode {
        case .day:
            return (MealScheduleCalendar.startOfDay(selectedDate), 1)
        case .week:
            let start = weekDays.first ?? MealScheduleCalendar.startOfDay(selectedDate)
            return (start, weekDays.count)
        case .month:
            let monthDays = MealScheduleCalendar.daysInMonth(containing: selectedDate)
            let start = monthDays.first ?? MealScheduleCalendar.startOfDay(selectedDate)
            return (start, monthDays.count)
        }
    }

    @ViewBuilder
    private func planMealSlotButton(for slot: MealSlot) -> some View {
        Button {
            openPlanMeals(for: selectedDate, mealSlots: [slot])
        } label: {
            Text("+ Plan \(slot.label)")
                .foregroundStyle(.blue)
        }
        .buttonStyle(.plain)
        .disabled(isApplyingMealPlan)
    }

    @ViewBuilder
    private func planMealsButton(for day: Date) -> some View {
        Button {
            openPlanMeals(for: day)
        } label: {
            Text("+ Plan meals")
                .foregroundStyle(.blue)
        }
        .buttonStyle(.plain)
        .disabled(isApplyingMealPlan)
    }
}

private struct MealRecipePickerContext: Identifiable {
    let mealID: UUID

    var id: UUID { mealID }
}

private struct ScheduledMealEditRow: View {
    @Bindable var meal: ScheduledMeal
    let recipes: [Recipe]
    var showsMealSlotLabel: Bool = true
    let onOpenPicker: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showsMealSlotLabel {
                Text(meal.mealSlot.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            HStack(alignment: .center, spacing: 12) {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Delete meal")

                RecipeImportEntryRow(
                    recipeID: $meal.recipeID,
                    servings: $meal.servings,
                    recipes: recipes,
                    onOpenPicker: onOpenPicker
                )
            }
        }
        .padding(.vertical, 2)
    }
}

private struct ScheduledMealRow: View {
    let meal: ScheduledMeal
    let recipe: Recipe?
    var showsMealSlotLabel: Bool = true
    @Environment(CookingSessionManager.self) private var cookingSession

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showsMealSlotLabel {
                Text(meal.mealSlot.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if let recipe {
                RecipeRowView(
                    recipe: recipe,
                    isInProgress: cookingSession.isInProgress(recipe: recipe),
                    showsSummary: false,
                    servings: meal.servings
                )
            } else {
                Text("Recipe unavailable")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DietRootView()
    }
    .modelContainer(try! CookGPTModelContainer.make())
    .environment(CookingSessionManager.shared)
    .environment(AppSettingsStore.shared)
}
