//  ScheduledMeal.swift
//  Cook GPT
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
        self.servings = servings
    }
}
