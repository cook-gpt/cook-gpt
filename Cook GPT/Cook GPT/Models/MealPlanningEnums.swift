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

enum WeekStartSetting: String, CaseIterable, Identifiable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: String { rawValue }

    var label: String {
        switch self {
        case .monday: "Monday"
        case .tuesday: "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday: "Thursday"
        case .friday: "Friday"
        case .saturday: "Saturday"
        case .sunday: "Sunday"
        }
    }

    var firstWeekday: Int {
        switch self {
        case .sunday: 1
        case .monday: 2
        case .tuesday: 3
        case .wednesday: 4
        case .thursday: 5
        case .friday: 6
        case .saturday: 7
        }
    }

    static func weekdayName(for firstWeekday: Int) -> String {
        let symbols = Calendar.current.weekdaySymbols
        guard firstWeekday >= 1, firstWeekday <= symbols.count else { return "—" }
        return symbols[firstWeekday - 1]
    }
}
