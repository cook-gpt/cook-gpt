//  DietRootView.swift
//  Cook GPT
//
//  Meals tab: day/week/month schedule browsing and meal management.
//

import SwiftUI
import SwiftData

struct DietRootView: View {
    @Query(filter: #Predicate<DietProfile> { $0.isActive == true })
    private var activeProfiles: [DietProfile]

    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @State private var viewMode: ScheduleViewMode = .week
    @State private var selectedDate = Date()
    @State private var isSchedulingMeal = false
    @State private var isPlanningMeals = false
    @State private var mealToEdit: ScheduledMeal?

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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Plan meals") {
                    isPlanningMeals = true
                }
                .disabled(activeProfile == nil)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isSchedulingMeal = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(activeProfile == nil)
            }
        }
        .sheet(isPresented: $isSchedulingMeal) {
            ScheduleMealSheet(defaultDate: selectedDate)
        }
        .sheet(item: $mealToEdit) { meal in
            ScheduleMealSheet(existingMeal: meal)
        }
        .sheet(isPresented: $isPlanningMeals) {
            if let profile = activeProfile {
                PlanMealsSheet(profile: profile)
            }
        }
        .onChange(of: settings.isResettingData) { _, isResetting in
            if isResetting {
                isSchedulingMeal = false
                isPlanningMeals = false
                mealToEdit = nil
            }
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
                    if let meal = visibleMeals.first(where: { $0.mealSlot == slot }) {
                        ScheduledMealRow(meal: meal)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                mealToEdit = meal
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteMeal(meal)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    } else {
                        Text("Nothing scheduled")
                            .foregroundStyle(.secondary)
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
                    let dayMeals = scheduledMeals.filter { MealScheduleCalendar.isSameDay($0.day, day) }
                    if dayMeals.isEmpty {
                        Text("Nothing scheduled")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(dayMeals, id: \.id) { meal in
                            ScheduledMealRow(meal: meal)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    mealToEdit = meal
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteMeal(meal)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
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
                    if group.meals.isEmpty {
                        Text("Nothing scheduled")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(group.meals, id: \.id) { meal in
                            ScheduledMealRow(meal: meal)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    mealToEdit = meal
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteMeal(meal)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
        }
    }

    private var groupedMonthDays: [(day: Date, meals: [ScheduledMeal])] {
        MealScheduleCalendar.daysInMonth(containing: selectedDate).map { day in
            let meals = scheduledMeals.filter { MealScheduleCalendar.isSameDay($0.day, day) }
            return (day: day, meals: meals)
        }
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

    private func deleteMeal(_ meal: ScheduledMeal) {
        modelContext.delete(meal)
        try? modelContext.save()
    }
}

private struct ScheduledMealRow: View {
    let meal: ScheduledMeal

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(meal.mealSlot.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(meal.servings) servings")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let recipe = meal.recipe {
                Text(recipe.title)
                    .font(.headline)
                Text("\(recipe.totalMinutes) min · \(recipe.difficulty.label)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("No recipe")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        DietRootView()
    }
    .modelContainer(try! CookGPTModelContainer.make())
    .environment(AppSettingsStore.shared)
}
