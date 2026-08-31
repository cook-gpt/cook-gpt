//  MealPlanner.swift
//  CookGPT
//
//  Selects diet-matching recipes and inserts scheduled meals.
//

import Foundation
import SwiftData

struct MealPlanRequest {
    let startDate: Date
    let numberOfDays: Int
    let servings: Int
    let dietType: DietType
    let mealSlots: [MealSlot]
}

enum MealPlanner {
    static func eligibleRecipes(
        dietType: DietType,
        from recipes: [Recipe],
        for mealSlot: MealSlot
    ) -> [Recipe] {
        let excluded = AppSettingsStore.mealPlannerExcludedCategoryIDs
        let breakfastCategoryID = AppSettingsStore.breakfastCategoryID

        let slotFiltered = recipes.filter { recipe in
            let tags = Set(recipe.tags)
            guard tags.isDisjoint(with: excluded) else { return false }

            switch mealSlot {
            case .breakfast:
                return tags.contains(breakfastCategoryID)
            case .lunch, .dinner:
                return !tags.contains(breakfastCategoryID)
            }
        }

        let categories = Set(dietType.preferredCategoryIDs)

        let filtered: [Recipe]
        if categories.isEmpty {
            filtered = slotFiltered
        } else {
            filtered = slotFiltered.filter { recipe in
                !Set(recipe.tags).isDisjoint(with: categories)
            }
        }

        return filtered.sorted { lhs, rhs in
            if lhs.isFavorite != rhs.isFavorite {
                return lhs.isFavorite && !rhs.isFavorite
            }
            return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }

    @MainActor
    static func planMeals(
        startingAt startDate: Date,
        numberOfDays: Int,
        servings: Int,
        dietType: DietType,
        mealSlots: [MealSlot],
        recipes: [Recipe],
        context: ModelContext
    ) {
        guard !mealSlots.isEmpty else { return }

        let orderedMealSlots = mealSlots.sorted { $0.displayOrder < $1.displayOrder }
        let candidatesBySlot = Dictionary(uniqueKeysWithValues: orderedMealSlots.map { slot in
            (slot, eligibleRecipes(dietType: dietType, from: recipes, for: slot))
        })

        guard candidatesBySlot.values.contains(where: { !$0.isEmpty }) else { return }

        let rangeStart = MealScheduleCalendar.startOfDay(startDate)
        guard let rangeEnd = MealScheduleCalendar.calendar.date(byAdding: .day, value: numberOfDays - 1, to: rangeStart) else {
            return
        }

        deleteScheduledMeals(
            from: rangeStart,
            through: rangeEnd,
            mealSlots: Set(orderedMealSlots),
            context: context
        )
        try? context.save()

        var recipeIndexBySlot: [MealSlot: Int] = [:]
        let days = MealScheduleCalendar.dates(from: rangeStart, through: rangeEnd)

        for day in days {
            for slot in orderedMealSlots {
                guard let candidates = candidatesBySlot[slot], !candidates.isEmpty else { continue }

                let index = recipeIndexBySlot[slot, default: 0]
                let recipe = candidates[index % candidates.count]
                recipeIndexBySlot[slot] = index + 1

                let scheduled = ScheduledMeal(
                    day: day,
                    mealSlot: slot,
                    recipe: recipe,
                    servings: servings
                )
                context.insert(scheduled)
            }
        }

        try? context.save()
    }

    @MainActor
    private static func deleteScheduledMeals(
        from rangeStart: Date,
        through rangeEnd: Date,
        mealSlots: Set<MealSlot>,
        context: ModelContext
    ) {
        let predicate = #Predicate<ScheduledMeal> { meal in
            meal.day >= rangeStart && meal.day <= rangeEnd
        }
        let descriptor = FetchDescriptor<ScheduledMeal>(predicate: predicate)

        guard let mealsInRange = try? context.fetch(descriptor) else { return }

        for meal in mealsInRange where mealSlots.contains(meal.mealSlot) {
            context.delete(meal)
        }
    }
}
