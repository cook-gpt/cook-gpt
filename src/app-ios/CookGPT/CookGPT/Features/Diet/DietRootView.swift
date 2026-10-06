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

private struct PlanMealsPresentation: Identifiable {
    let id = UUID()
    let startDate: Date
    let numberOfDays: Int
    let includedMealSlots: Set<MealSlot>
    let initialServings: Int?
}

private struct AddToGroceriesPresentation: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let includedMealSlots: Set<MealSlot>
}

struct DietRootView: View {
    @Query(filter: #Predicate<DietProfile> { $0.isActive == true })
    private var activeProfiles: [DietProfile]

    @Query(sort: \DietProfile.name) private var dietProfiles: [DietProfile]

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]
    @Query(sort: \GroceryList.name) private var groceryLists: [GroceryList]
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings
    @Environment(AppNavigationStore.self) private var navigation
    @Environment(CookingSessionManager.self) private var cookingSession

    @State private var viewMode: ScheduleViewMode = .week
    @State private var selectedDate = Date()
    @State private var planMealsPresentation: PlanMealsPresentation?
    @State private var addToGroceriesPresentation: AddToGroceriesPresentation?
    @State private var isApplyingMealPlan = false
    @State private var isEditingMeals = false
    @State private var mealRecipePickerContext: MealRecipePickerContext?
    @State private var showDeleteRangeConfirmation = false
    @State private var mealDeleteConfirmation: MealDeleteConfirmation?
    @State private var trustedScheduledMealIDs: Set<UUID>?

    private struct MealDeleteConfirmation: Identifiable {
        let id: UUID
        let message: String
    }

    private var activeProfile: DietProfile? {
        activeProfiles.first
    }

    private var activeRecipes: [Recipe] {
        recipes.filter { !navigation.recipeIDsPendingDeletion.contains($0.id) }
    }

    private var validRecipeIDs: Set<UUID> {
        Set(activeRecipes.map(\.id))
    }

    private var effectiveTrustedMealIDs: Set<UUID> {
        trustedScheduledMealIDs ?? Set(scheduledMeals.map(\.id))
    }

    /// Meals whose recipe still exists, plus empty meal slots awaiting a recipe.
    private var activeScheduledMeals: [ScheduledMeal] {
        scheduledMeals.filter { meal in
            guard effectiveTrustedMealIDs.contains(meal.id) else { return false }
            if navigation.hiddenMealIDs.contains(meal.id) { return false }
            if navigation.mealIDsPendingDeletion.contains(meal.id) { return false }
            guard let recipeID = meal.recipeID else { return true }
            if navigation.recipeIDsPendingDeletion.contains(recipeID) { return false }
            return validRecipeIDs.contains(recipeID)
        }
    }

    private var weekDays: [Date] {
        // Observe week-start preference so the week grid refreshes when it changes in Settings.
        let _ = settings.weekStart
        return MealScheduleCalendar.daysInWeek(containing: selectedDate)
    }

    private var visibleMeals: [ScheduledMeal] {
        switch viewMode {
        case .day:
            return activeScheduledMeals.filter { MealScheduleCalendar.isSameDay($0.day, selectedDate) }
        case .week:
            let days = Set(weekDays.map { MealScheduleCalendar.startOfDay($0) })
            return activeScheduledMeals.filter { days.contains(MealScheduleCalendar.startOfDay($0.day)) }
        case .month:
            let days = Set(
                MealScheduleCalendar.daysInMonth(containing: selectedDate).map {
                    MealScheduleCalendar.startOfDay($0)
                }
            )
            return activeScheduledMeals.filter { days.contains(MealScheduleCalendar.startOfDay($0.day)) }
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
            recipes: activeRecipes,
            navigation: navigation
        )
    }

    private var primaryGroceryList: GroceryList? {
        groceryLists.first
    }

    private var hasExportableMeals: Bool {
        visibleMeals.contains { meal in
            guard let recipeID = meal.recipeID else { return false }
            return activeRecipes.contains { $0.id == recipeID }
        }
    }

    private var canAddVisibleMealsToGroceries: Bool {
        primaryGroceryList != nil
    }

    private var canDeleteVisibleMeals: Bool {
        !visibleMeals.isEmpty
    }

    private var canOpenMealPlanner: Bool {
        MealPlanner.canOpenMealPlanner(from: recipes)
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
            if let recipe = activeRecipes.first(where: { $0.id == route.recipeID }) {
                RecipeDetailView(recipe: recipe, initialServings: route.servings)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                if activeProfile != nil && !isApplyingMealPlan {
                    if isEditingMeals {
                        Button {
                            showDeleteRangeConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(canDeleteVisibleMeals ? .red : .secondary)
                        }
                        .disabled(!canDeleteVisibleMeals)
                        .accessibilityLabel("Delete meals in current range")
                    } else {
                        Button {
                            openAddToGroceriesSheet()
                        } label: {
                            Image(systemName: "cart.badge.plus")
                        }
                        .disabled(!canAddVisibleMealsToGroceries)
                        .accessibilityLabel("Add scheduled meals to shopping list")

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
                    recipes: activeRecipes,
                    excludedRecipeIDs: [],
                    onSelect: { selectedRecipe in
                        if let meal = activeScheduledMeals.first(where: { $0.id == context.mealID }) {
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
        .sheet(item: $planMealsPresentation) { presentation in
            if let profile = activeProfile {
                PlanMealsSheet(
                    profile: profile,
                    startDate: presentation.startDate,
                    numberOfDays: presentation.numberOfDays,
                    includedMealSlots: presentation.includedMealSlots,
                    initialServings: presentation.initialServings,
                    onPlan: applyMealPlan
                )
            }
        }
        .sheet(item: $addToGroceriesPresentation) { presentation in
            AddMealsToGroceriesSheet(
                meals: activeScheduledMeals,
                recipes: activeRecipes,
                startDate: presentation.startDate,
                endDate: presentation.endDate,
                includedMealSlots: presentation.includedMealSlots,
                onAdd: addMealsToGroceries
            )
        }
        .alert("Delete meals?", isPresented: $showDeleteRangeConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteVisibleMeals()
            }
        } message: {
            Text("This will remove all scheduled meals for \(periodTitle).")
        }
        .alert(
            "Delete meal?",
            isPresented: Binding(
                get: { mealDeleteConfirmation != nil },
                set: { isPresented in
                    if !isPresented {
                        mealDeleteConfirmation = nil
                    }
                }
            )
        ) {
            Button("Cancel", role: .cancel) {
                mealDeleteConfirmation = nil
            }
            Button("Delete", role: .destructive) {
                if let confirmation = mealDeleteConfirmation,
                   let meal = scheduledMeals.first(where: { $0.id == confirmation.id }) {
                    deleteMeal(meal)
                }
                mealDeleteConfirmation = nil
            }
        } message: {
            if let confirmation = mealDeleteConfirmation {
                Text(confirmation.message)
            }
        }
        .onChange(of: settings.isResettingData) { _, isResetting in
            if isResetting {
                planMealsPresentation = nil
                addToGroceriesPresentation = nil
                isApplyingMealPlan = false
                isEditingMeals = false
                mealRecipePickerContext = nil
                showDeleteRangeConfirmation = false
                mealDeleteConfirmation = nil
            }
        }
        .onAppear {
            ScheduledMeal.removeOrphanedMeals(
                validRecipeIDs: Set(recipes.map(\.id)),
                in: modelContext
            )
            syncMealSlotCache()
        }
        .onChange(of: scheduledMeals.map(\.id)) { _, _ in
            syncMealSlotCache()
        }
        .onChange(of: navigation.mealScheduleSyncToken) { _, _ in
            syncMealSlotCache()
        }
    }

    private func syncMealSlotCache() {
        let trustedMealIDs = RecipeDeletion.presentMealIDs(in: modelContext)
        trustedScheduledMealIDs = trustedMealIDs
        navigation.cacheMealSlotsIfNeeded(from: scheduledMeals, trustedMealIDs: trustedMealIDs)
        navigation.pruneDeletedMeals(stillPresentMealIDs: trustedMealIDs)
    }

    private func applyMealPlan(_ request: MealPlanRequest) {
        isApplyingMealPlan = true

        Task { @MainActor in
            defer { isApplyingMealPlan = false }

            await Task.yield()

            let recipeDescriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.title)])
            let recipes = (try? modelContext.fetch(recipeDescriptor)) ?? []

            guard let profile = dietProfiles.first(where: { $0.id == request.dietProfileID }) else {
                return
            }

            MealPlanner.planMeals(
                startingAt: request.startDate,
                numberOfDays: request.numberOfDays,
                servings: request.servings,
                profile: profile,
                mealSlots: request.mealSlots,
                recipes: recipes,
                context: modelContext,
                globalRules: settings.globalMealPlanningRules
            )

            syncMealSlotCache()
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
                    LabeledContent("Diet", value: profile.name)
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
        activeScheduledMeals
            .filter { MealScheduleCalendar.isSameDay($0.day, day) }
            .sortedByMealSlot(using: navigation)
    }

    private func meal(for day: Date, slot: MealSlot) -> ScheduledMeal? {
        activeScheduledMeals.first { meal in
            MealScheduleCalendar.isSameDay(meal.day, day)
                && navigation.mealSlot(for: meal.id) == slot
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
        navigation.cacheMealSlot(from: meal)
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
            mealSlotLabel: navigation.mealSlotLabel(for: meal.id),
            recipes: activeRecipes,
            showsMealSlotLabel: showsMealSlotLabel,
            onOpenPicker: { mealRecipePickerContext = MealRecipePickerContext(mealID: meal.id) },
            onDelete: { deleteMeal(meal) }
        )
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 12))
    }

    @ViewBuilder
    private func scheduledMealListRow(_ meal: ScheduledMeal, showsMealSlotLabel: Bool = true) -> some View {
        let recipeDisplay = recipeRowDisplay(for: meal)

        Group {
            if let recipeDisplay {
                NavigationLink(
                    value: MealRecipeDetailRoute(recipeID: recipeDisplay.id, servings: meal.servings)
                ) {
                    ScheduledMealRow(
                        mealSlotLabel: navigation.mealSlotLabel(for: meal.id),
                        recipeDisplay: recipeDisplay,
                        showsMealSlotLabel: showsMealSlotLabel
                    )
                }
            } else {
                ScheduledMealRow(
                    mealSlotLabel: navigation.mealSlotLabel(for: meal.id),
                    recipeDisplay: nil,
                    showsMealSlotLabel: showsMealSlotLabel
                )
            }
        }
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 12))
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                mealDeleteConfirmation = MealDeleteConfirmation(
                    id: meal.id,
                    message: mealDeleteMessage(for: meal)
                )
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func mealDeleteMessage(for meal: ScheduledMeal) -> String {
        if let recipeDisplay = recipeRowDisplay(for: meal) {
            return String(
                format: String(localized: "“%@” will be removed from your meal schedule."),
                recipeDisplay.title
            )
        }

        return String(localized: "This planned meal will be removed from your meal schedule.")
    }

    private func recipeRowDisplay(for meal: ScheduledMeal) -> RecipeRowDisplayData? {
        guard let recipeID = meal.recipeID else { return nil }
        guard !navigation.recipeIDsPendingDeletion.contains(recipeID) else { return nil }
        guard let recipe = activeRecipes.first(where: { $0.id == recipeID }) else { return nil }

        return RecipeRowDisplayData(
            recipe: recipe,
            isInProgress: cookingSession.isInProgress(recipe: recipe),
            servings: meal.servings
        )
    }

    private func deleteMeal(_ meal: ScheduledMeal) {
        navigation.registerDeletedMealIDs([meal.id])
        modelContext.delete(meal)
        try? modelContext.save()
        syncMealSlotCache()
    }

    private func deleteVisibleMeals() {
        navigation.registerDeletedMealIDs(Set(visibleMeals.map(\.id)))
        for meal in visibleMeals {
            modelContext.delete(meal)
        }
        try? modelContext.save()
        syncMealSlotCache()
    }

    private func addToGroceriesDefaults() -> (start: Date, end: Date, mealSlots: Set<MealSlot>) {
        let days = exportDays
        let start = days.first ?? MealScheduleCalendar.startOfDay(selectedDate)
        let end = days.last ?? start

        let slotsInRange = Set(
            visibleMeals.compactMap { meal -> MealSlot? in
                guard meal.recipeID != nil else { return nil }
                return navigation.mealSlot(for: meal.id)
            }
        )
        let defaultSlots = slotsInRange.isEmpty
            ? Set([MealSlot.lunch, .dinner])
            : slotsInRange

        return (start, end, defaultSlots)
    }

    private func openAddToGroceriesSheet() {
        let defaults = addToGroceriesDefaults()
        addToGroceriesPresentation = AddToGroceriesPresentation(
            startDate: defaults.start,
            endDate: defaults.end,
            includedMealSlots: defaults.mealSlots
        )
    }

    private func addMealsToGroceries(_ meals: [ScheduledMeal], startDate: Date, endDate: Date) {
        guard let list = primaryGroceryList else { return }

        let recipeEntries = ShoppingListGenerator.recipes(
            from: meals,
            allRecipes: activeRecipes
        )
        guard !recipeEntries.isEmpty else { return }

        let imported = ShoppingListGenerator.aggregate(recipes: recipeEntries)
        let finalItems = ShoppingListGenerator.merge(aggregated: imported, with: list.items)

        list.items.forEach { modelContext.delete($0) }
        list.items = []

        for item in finalItems {
            let groceryItem = GroceryItem(
                name: item.name,
                quantity: item.quantity,
                unit: item.unit,
                isChecked: item.isChecked,
                sortOrder: 0,
                list: list
            )
            modelContext.insert(groceryItem)
            list.items.append(groceryItem)
        }

        list.normalizePartitionedSortOrders()

        let sourceDescription = ShoppingListGenerator.sourceLabel(
            for: .custom,
            start: startDate,
            end: endDate
        )
        if list.sourceDescription.isEmpty {
            list.sourceDescription = sourceDescription
        } else {
            list.sourceDescription = "\(list.sourceDescription) + \(sourceDescription)"
        }
        list.generatedAt = .now
        try? modelContext.save()

        navigation.openGroceries(highlightingItemKeys: Set(imported.map(\.identityKey)))
    }

    private func finishEditingMeals() {
        for meal in visibleMeals {
            meal.servings = min(max(meal.servings, 1), 24)

            if let recipeID = meal.recipeID,
               let recipe = activeRecipes.first(where: { $0.id == recipeID }) {
                meal.recipe = recipe
            } else {
                navigation.registerDeletedMealIDs([meal.id])
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
        planMealsPresentation = PlanMealsPresentation(
            startDate: defaults.start,
            numberOfDays: defaults.days,
            includedMealSlots: mealSlots ?? defaultPlanMealSlots,
            initialServings: servings
        )
    }

    private var defaultPlanMealSlots: Set<MealSlot> {
        let profile = activeProfile ?? DietProfile.balancedPreset()
        if MealPlanner.requiresExclusiveLunchOrDinner(
            profile: profile,
            from: recipes,
            globalRules: settings.globalMealPlanningRules
        ) {
            return [.lunch]
        }
        return [.lunch, .dinner]
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
    let mealSlotLabel: String
    let recipes: [Recipe]
    var showsMealSlotLabel: Bool = true
    let onOpenPicker: () -> Void
    let onDelete: () -> Void

    init(
        meal: ScheduledMeal,
        mealSlotLabel: String,
        recipes: [Recipe],
        showsMealSlotLabel: Bool = true,
        onOpenPicker: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.meal = meal
        self.mealSlotLabel = mealSlotLabel
        self.recipes = recipes
        self.showsMealSlotLabel = showsMealSlotLabel
        self.onOpenPicker = onOpenPicker
        self.onDelete = onDelete
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showsMealSlotLabel {
                Text(mealSlotLabel)
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
    let mealSlotLabel: String
    let recipeDisplay: RecipeRowDisplayData?
    var showsMealSlotLabel: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if showsMealSlotLabel {
                Text(mealSlotLabel)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            if let recipeDisplay {
                RecipeRowView(display: recipeDisplay, showsSummary: false)
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
    .environment(AppNavigationStore.shared)
}
