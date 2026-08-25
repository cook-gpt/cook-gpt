import Foundation
import SwiftData

@Model
final class DietProfile {
    var name: String
    var dailyCalorieGoal: Int
    var proteinGrams: Int
    var carbGrams: Int
    var fatGrams: Int
    var isActive: Bool

    init(
        name: String,
        dailyCalorieGoal: Int,
        proteinGrams: Int,
        carbGrams: Int,
        fatGrams: Int,
        isActive: Bool = false
    ) {
        self.name = name
        self.dailyCalorieGoal = dailyCalorieGoal
        self.proteinGrams = proteinGrams
        self.carbGrams = carbGrams
        self.fatGrams = fatGrams
        self.isActive = isActive
    }
}
