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
    let dietProfileID: UUID
    let mealSlots: [MealSlot]
}

enum MealPlanner {
    static func canOpenMealPlanner(
        from recipes: [Recipe],
        globalRules: GlobalMealPlanningRules = .default
    ) -> Bool {
        guard !recipes.isEmpty else { return false }

        let balanced = DietProfile.balancedPreset()
        return MealSlot.allCases.contains { slot in
            !eligibleRecipes(profile: balanced, globalRules: globalRules, from: recipes, for: slot).isEmpty
        }
    }

    static func requiresExclusiveLunchOrDinner(
        profile: DietProfile,
        from recipes: [Recipe],
        globalRules: GlobalMealPlanningRules = .default
    ) -> Bool {
        let lunchDinnerIDs = Set(
            eligibleRecipes(profile: profile, globalRules: globalRules, from: recipes, for: .lunch).map(\.id)
        )
        return lunchDinnerIDs.count == 1
    }

    static func availableDietProfiles(
        from recipes: [Recipe],
        profiles: [DietProfile],
        for mealSlots: [MealSlot],
        globalRules: GlobalMealPlanningRules = .default
    ) -> [DietProfile] {
        profiles.filter { profile in
            canPlanMeals(profile: profile, globalRules: globalRules, from: recipes, for: mealSlots)
                && (!profile.requiresCategoryVariety
                    || hasMinimumCategoryVariety(
                        profile: profile,
                        globalRules: globalRules,
                        from: recipes,
                        for: mealSlots
                    ))
        }
    }

    static func canPlanMeals(
        profile: DietProfile,
        globalRules: GlobalMealPlanningRules = .default,
        from recipes: [Recipe],
        for mealSlots: [MealSlot]
    ) -> Bool {
        guard !mealSlots.isEmpty else { return false }

        guard mealSlots.allSatisfy({ slot in
            !eligibleRecipes(profile: profile, globalRules: globalRules, from: recipes, for: slot).isEmpty
        }) else {
            return false
        }

        let lunchAndDinner = mealSlots.contains(.lunch) && mealSlots.contains(.dinner)
        guard lunchAndDinner else { return true }

        let lunchIDs = Set(
            eligibleRecipes(profile: profile, globalRules: globalRules, from: recipes, for: .lunch).map(\.id)
        )
        let dinnerIDs = Set(
            eligibleRecipes(profile: profile, globalRules: globalRules, from: recipes, for: .dinner).map(\.id)
        )
        return lunchIDs.union(dinnerIDs).count >= 2
    }

    static func hasMinimumCategoryVariety(
        profile: DietProfile,
        globalRules: GlobalMealPlanningRules = .default,
        from recipes: [Recipe],
        for mealSlots: [MealSlot]
    ) -> Bool {
        let eligibleIDs = Set(
            mealSlots.flatMap { slot in
                eligibleRecipes(profile: profile, globalRules: globalRules, from: recipes, for: slot).map(\.id)
            }
        )

        var countsByCategory: [String: Int] = [:]
        for recipe in recipes where eligibleIDs.contains(recipe.id) {
            for tag in recipe.tags {
                countsByCategory[tag, default: 0] += 1
            }
        }

        return countsByCategory.values.contains { $0 >= 2 }
    }

    static func eligibleRecipes(
        profile: DietProfile,
        globalRules: GlobalMealPlanningRules = .default,
        from recipes: [Recipe],
        for mealSlot: MealSlot
    ) -> [Recipe] {
        let mandatoryBlocks = DietRulesEvaluator.mandatoryBlocks(
            global: globalRules,
            profile: profile,
            for: mealSlot
        )
        let forbidden = DietRulesEvaluator.forbiddenCategoryIDs(
            global: globalRules,
            profile: profile,
            for: mealSlot
        )

        let filtered = recipes.filter { recipe in
            DietRulesEvaluator.recipeMatches(
                tags: Set(recipe.tags),
                mandatoryBlocks: mandatoryBlocks,
                forbidden: forbidden
            )
        }

        return filtered.sorted { lhs, rhs in
            let lhsPriority = mealPlanningPriority(for: lhs)
            let rhsPriority = mealPlanningPriority(for: rhs)
            if lhsPriority != rhsPriority {
                return lhsPriority > rhsPriority
            }
            return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        }
    }

    /// Higher scores are preferred when auto-planning meals.
    private static func mealPlanningPriority(for recipe: Recipe) -> Int {
        let ratingPoints = (recipe.rating ?? 0) * 10
        let difficultyPoints: Int
        switch recipe.difficulty {
        case .easy: difficultyPoints = 10
        case .medium: difficultyPoints = 6
        case .hard: difficultyPoints = 2
        }
        let ratedBonus = recipe.rating != nil ? 100 : 0
        return ratedBonus + ratingPoints + difficultyPoints
    }

    @MainActor
    static func planMeals(
        startingAt startDate: Date,
        numberOfDays: Int,
        servings: Int,
        profile: DietProfile,
        mealSlots: [MealSlot],
        recipes: [Recipe],
        context: ModelContext,
        globalRules: GlobalMealPlanningRules = .default
    ) {
        guard !mealSlots.isEmpty else { return }

        let orderedMealSlots = mealSlots.sorted { $0.displayOrder < $1.displayOrder }
        let candidatesBySlot = Dictionary(uniqueKeysWithValues: orderedMealSlots.map { slot in
            (slot, eligibleRecipes(profile: profile, globalRules: globalRules, from: recipes, for: slot))
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
            var lunchDinnerRecipeIDs = Set<UUID>()

            for slot in orderedMealSlots {
                guard let candidates = candidatesBySlot[slot], !candidates.isEmpty else { continue }

                let startIndex = recipeIndexBySlot[slot, default: 0]
                let excluding = (slot == .lunch || slot == .dinner) ? lunchDinnerRecipeIDs : Set<UUID>()
                let selection = pickNextRecipe(
                    from: candidates,
                    startingAt: startIndex,
                    excluding: excluding
                )
                recipeIndexBySlot[slot] = selection.nextIndex

                if slot == .lunch || slot == .dinner {
                    lunchDinnerRecipeIDs.insert(selection.recipe.id)
                }

                let scheduled = ScheduledMeal(
                    day: day,
                    mealSlot: slot,
                    recipe: selection.recipe,
                    servings: servings
                )
                context.insert(scheduled)
            }
        }

        try? context.save()
    }

    private static func pickNextRecipe(
        from candidates: [Recipe],
        startingAt startIndex: Int,
        excluding excludedIDs: Set<UUID>
    ) -> (recipe: Recipe, nextIndex: Int) {
        guard !candidates.isEmpty else {
            preconditionFailure("pickNextRecipe requires at least one candidate")
        }

        if excludedIDs.isEmpty {
            let recipe = candidates[startIndex % candidates.count]
            return (recipe, startIndex + 1)
        }

        for offset in 0..<candidates.count {
            let index = (startIndex + offset) % candidates.count
            let recipe = candidates[index]
            if !excludedIDs.contains(recipe.id) {
                return (recipe, startIndex + offset + 1)
            }
        }

        let recipe = candidates[startIndex % candidates.count]
        return (recipe, startIndex + 1)
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
