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
    static func eligibleRecipes(dietType: DietType, from recipes: [Recipe]) -> [Recipe] {
        let excluded = AppSettingsStore.mealPlannerExcludedCategoryIDs
        let plannerRecipes = recipes.filter { recipe in
            Set(recipe.tags).isDisjoint(with: excluded)
        }

        let categories = Set(dietType.preferredCategoryIDs)

        let filtered: [Recipe]
        if categories.isEmpty {
            filtered = plannerRecipes
        } else {
            filtered = plannerRecipes.filter { recipe in
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
        let candidates = eligibleRecipes(dietType: dietType, from: recipes)
        guard !candidates.isEmpty, !mealSlots.isEmpty else { return }

        let rangeStart = MealScheduleCalendar.startOfDay(startDate)
        guard let rangeEnd = MealScheduleCalendar.calendar.date(byAdding: .day, value: numberOfDays - 1, to: rangeStart) else {
            return
        }

        deleteScheduledMeals(from: rangeStart, through: rangeEnd, context: context)
        try? context.save()

        var recipeIndex = 0
        let days = MealScheduleCalendar.dates(from: rangeStart, through: rangeEnd)

        for day in days {
            for slot in mealSlots {
                let recipe = candidates[recipeIndex % candidates.count]
                recipeIndex += 1

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
        context: ModelContext
    ) {
        let predicate = #Predicate<ScheduledMeal> { meal in
            meal.day >= rangeStart && meal.day <= rangeEnd
        }
        let descriptor = FetchDescriptor<ScheduledMeal>(predicate: predicate)

        guard let mealsToDelete = try? context.fetch(descriptor) else { return }

        for meal in mealsToDelete {
            context.delete(meal)
        }
    }
}
