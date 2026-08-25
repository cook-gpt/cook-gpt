import Foundation

enum IngredientCategory: String, Codable, CaseIterable {
    case produce
    case dairy
    case protein
    case grain
    case spice
    case other
}

enum RecipeDifficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case hard

    var label: String {
        rawValue.capitalized
    }

    var sortOrder: Int {
        switch self {
        case .easy: 0
        case .medium: 1
        case .hard: 2
        }
    }
}

enum MealType: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack

    var label: String {
        rawValue.capitalized
    }
}
