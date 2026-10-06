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
        switch self {
        case .breakfast: String(localized: "Breakfast")
        case .lunch: String(localized: "Lunch")
        case .dinner: String(localized: "Dinner")
        }
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
        case .balanced: String(localized: "Balanced")
        case .vegetarian: String(localized: "Vegetarian")
        case .vegan: String(localized: "Vegan")
        case .highProtein: String(localized: "High protein")
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
        switch self {
        case .day: String(localized: "Day")
        case .week: String(localized: "Week")
        case .month: String(localized: "Month")
        }
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
        case .today: String(localized: "Today")
        case .week: String(localized: "This week")
        case .month: String(localized: "This month")
        case .custom: String(localized: "Custom range")
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
        case .monday: String(localized: "Monday")
        case .tuesday: String(localized: "Tuesday")
        case .wednesday: String(localized: "Wednesday")
        case .thursday: String(localized: "Thursday")
        case .friday: String(localized: "Friday")
        case .saturday: String(localized: "Saturday")
        case .sunday: String(localized: "Sunday")
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
