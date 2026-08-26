import Foundation
import SwiftData

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
