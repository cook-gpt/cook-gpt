//  ScheduledMeal.swift
//  CookGPT
//
//  A recipe scheduled on a day and meal slot with servings.
//

import Foundation
import SwiftData

/// Recipe scheduled on a calendar day and meal slot.
@Model
final class ScheduledMeal {
    var id: UUID
    var day: Date
    var mealSlot: MealSlot
    var servings: Int
    var recipeID: UUID?
    var recipe: Recipe?

    init(
        id: UUID = UUID(),
        day: Date,
        mealSlot: MealSlot,
        recipe: Recipe?,
        servings: Int = 2
    ) {
        self.id = id
        self.day = MealScheduleCalendar.startOfDay(day)
        self.mealSlot = mealSlot
        self.recipe = recipe
        self.recipeID = recipe?.id
        self.servings = servings
    }
}

extension ScheduledMeal {
    @MainActor
    static func deleteMeals(referencing recipeID: UUID, in context: ModelContext) {
        let descriptor = FetchDescriptor<ScheduledMeal>()
        guard let meals = try? context.fetch(descriptor) else { return }

        var deletedAny = false
        for meal in meals where meal.recipeID == recipeID {
            context.delete(meal)
            deletedAny = true
        }

        if deletedAny {
            try? context.save()
        }
    }

    @MainActor
    static func removeOrphanedMeals(validRecipeIDs: Set<UUID>, in context: ModelContext) {
        let descriptor = FetchDescriptor<ScheduledMeal>()
        guard let meals = try? context.fetch(descriptor) else { return }

        var changed = false
        for meal in meals {
            guard let recipeID = meal.recipeID else { continue }

            if !validRecipeIDs.contains(recipeID) {
                context.delete(meal)
                changed = true
            }
        }

        if changed {
            try? context.save()
        }
    }
}

extension Array where Element == ScheduledMeal {
    func sortedByMealSlot(using navigation: AppNavigationStore) -> [ScheduledMeal] {
        sorted {
            navigation.mealSlotDisplayOrder(for: $0.id) < navigation.mealSlotDisplayOrder(for: $1.id)
        }
    }
}
