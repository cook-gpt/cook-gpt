//  MealPlanningEnums.swift
//  CookGPT
//
//  Meal slots, diet types, schedule views, shopping scopes, and week-start options.
//

import Foundation

enum MealSlot: String, Codable, CaseIterable {
    case breakfast
    case lunch
    case dinner

    var label: String {
        rawValue.capitalized
    }

    var displayOrder: Int {
        switch self {
        case .breakfast: 0
        case .lunch: 1
        case .dinner: 2
        }
    }

    static func plannerSlots(included: Set<MealSlot>) -> [MealSlot] {
        allCases.filter { included.contains($0) }
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
}
