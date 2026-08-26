import Foundation

enum MealSlot: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case dinner

    var label: String {
        rawValue.capitalized
    }

    static func plannerSlots(includeBreakfast: Bool) -> [MealSlot] {
        if includeBreakfast {
            return allCases
        }
        return allCases.filter { $0 != .breakfast }
    }
}

enum DietType: String, Codable, CaseIterable {
    case balanced
    case vegetarian
    case vegan
    case highProtein = "high-protein"

    var label: String {
        switch self {
        case .balanced: "Balanced"
        case .highProtein: "High protein"
        default: rawValue.capitalized
        }
    }

    var preferredCategoryIDs: [String] {
        switch self {
        case .balanced: []
        case .vegetarian: ["vegetarian", "vegan"]
        case .vegan: ["vegan"]
        case .highProtein: ["high-protein"]
        }
    }
}

enum ScheduleViewMode: String, CaseIterable {
    case day
    case week
    case month

    var label: String {
        rawValue.capitalized
    }
}

enum ShoppingListScope: String, CaseIterable, Identifiable {
    case today
    case week
    case month
    case custom

    var id: String { rawValue }

    var label: String {
        switch self {
        case .today: "Today"
        case .week: "This week"
        case .month: "This month"
        case .custom: "Custom range"
        }
    }
}
