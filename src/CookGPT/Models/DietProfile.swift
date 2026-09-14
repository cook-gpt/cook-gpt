//  DietProfile.swift
//  CookGPT
//
//  Custom diet profile with category rules for meal planning.
//

import Foundation
import SwiftData

/// User diet profile for meal planning filters.
@Model
final class DietProfile {
    var id: UUID
    var name: String
    var isActive: Bool

    var mandatoryCategoryIDs: [String]
    var forbiddenCategoryIDs: [String]

    var usesBreakfastSlotRules: Bool
    var usesLunchSlotRules: Bool
    var usesDinnerSlotRules: Bool

    var breakfastMandatoryCategoryIDs: [String]
    var breakfastForbiddenCategoryIDs: [String]
    var lunchMandatoryCategoryIDs: [String]
    var lunchForbiddenCategoryIDs: [String]
    var dinnerMandatoryCategoryIDs: [String]
    var dinnerForbiddenCategoryIDs: [String]

    init(
        id: UUID = UUID(),
        name: String,
        isActive: Bool = false,
        mandatoryCategoryIDs: [String] = [],
        forbiddenCategoryIDs: [String] = [],
        usesBreakfastSlotRules: Bool = false,
        usesLunchSlotRules: Bool = false,
        usesDinnerSlotRules: Bool = false,
        breakfastMandatoryCategoryIDs: [String] = [],
        breakfastForbiddenCategoryIDs: [String] = [],
        lunchMandatoryCategoryIDs: [String] = [],
        lunchForbiddenCategoryIDs: [String] = [],
        dinnerMandatoryCategoryIDs: [String] = [],
        dinnerForbiddenCategoryIDs: [String] = []
    ) {
        self.id = id
        self.name = name
        self.isActive = isActive
        self.mandatoryCategoryIDs = mandatoryCategoryIDs
        self.forbiddenCategoryIDs = forbiddenCategoryIDs
        self.usesBreakfastSlotRules = usesBreakfastSlotRules
        self.usesLunchSlotRules = usesLunchSlotRules
        self.usesDinnerSlotRules = usesDinnerSlotRules
        self.breakfastMandatoryCategoryIDs = breakfastMandatoryCategoryIDs
        self.breakfastForbiddenCategoryIDs = breakfastForbiddenCategoryIDs
        self.lunchMandatoryCategoryIDs = lunchMandatoryCategoryIDs
        self.lunchForbiddenCategoryIDs = lunchForbiddenCategoryIDs
        self.dinnerMandatoryCategoryIDs = dinnerMandatoryCategoryIDs
        self.dinnerForbiddenCategoryIDs = dinnerForbiddenCategoryIDs
    }
}

extension DietProfile {
    static func balancedPreset(isActive: Bool = false) -> DietProfile {
        DietProfile(name: String(localized: "Balanced"), isActive: isActive)
    }

    static func vegetarianPreset() -> DietProfile {
        DietProfile(
            name: String(localized: "Vegetarian"),
            mandatoryCategoryIDs: ["vegetarian", "vegan"]
        )
    }

    static func veganPreset() -> DietProfile {
        DietProfile(
            name: String(localized: "Vegan"),
            mandatoryCategoryIDs: ["vegan"]
        )
    }

    static func highProteinPreset() -> DietProfile {
        DietProfile(
            name: String(localized: "High protein"),
            mandatoryCategoryIDs: ["high-protein"]
        )
    }

    static func defaultPresets() -> [DietProfile] {
        [
            balancedPreset(isActive: true),
            vegetarianPreset(),
            veganPreset(),
            highProteinPreset(),
        ]
    }
}
