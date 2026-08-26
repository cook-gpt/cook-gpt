import Foundation
import SwiftData

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
        includeBreakfast: Bool,
        recipes: [Recipe],
        existingMeals: [ScheduledMeal],
        context: ModelContext
    ) {
        let candidates = eligibleRecipes(dietType: dietType, from: recipes)
        guard !candidates.isEmpty else { return }

        let rangeStart = MealScheduleCalendar.startOfDay(startDate)
        guard let rangeEnd = MealScheduleCalendar.calendar.date(byAdding: .day, value: numberOfDays - 1, to: rangeStart) else {
            return
        }

        for meal in existingMeals where meal.day >= rangeStart && meal.day <= rangeEnd {
            context.delete(meal)
        }

        var recipeIndex = 0
        let days = MealScheduleCalendar.dates(from: rangeStart, through: rangeEnd)

        let slots = MealSlot.plannerSlots(includeBreakfast: includeBreakfast)

        for day in days {
            for slot in slots {
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
}
