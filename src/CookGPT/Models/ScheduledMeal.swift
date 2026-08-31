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
        let predicate = #Predicate<ScheduledMeal> { meal in
            meal.recipeID == recipeID
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard let meals = try? context.fetch(descriptor) else { return }
        for meal in meals {
            context.delete(meal)
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
    func sortedByMealSlot() -> [ScheduledMeal] {
        sorted { $0.mealSlot.displayOrder < $1.mealSlot.displayOrder }
    }
}
