import Foundation
import SwiftData

@Model
final class MealLogEntry {
    var date: Date
    var mealType: MealType
    var calories: Int
    var recipe: Recipe?
    var note: String

    init(
        date: Date = .now,
        mealType: MealType,
        calories: Int,
        recipe: Recipe? = nil,
        note: String = ""
    ) {
        self.date = date
        self.mealType = mealType
        self.calories = calories
        self.recipe = recipe
        self.note = note
    }
}
