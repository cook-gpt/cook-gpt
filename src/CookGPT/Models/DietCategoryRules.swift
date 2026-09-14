//  DietCategoryRules.swift
//  CookGPT
//
//  Category rules for global meal planning and custom diet profiles.
//

import Foundation

struct DietCategoryRules: Codable, Hashable {
    var mandatoryCategoryIDs: [String] = []
    var forbiddenCategoryIDs: [String] = []

    static let empty = DietCategoryRules()
}

struct GlobalMealPlanningRules: Codable, Hashable {
    var allMealsForbiddenCategoryIDs: [String] = ["dessert"]
    var breakfast = DietCategoryRules(mandatoryCategoryIDs: ["breakfast"])
    var lunch = DietCategoryRules(forbiddenCategoryIDs: ["breakfast"])
    var dinner = DietCategoryRules(forbiddenCategoryIDs: ["breakfast"])

    static let `default` = GlobalMealPlanningRules()

    func rules(for slot: MealSlot) -> DietCategoryRules {
        switch slot {
        case .breakfast: breakfast
        case .lunch: lunch
        case .dinner: dinner
        }
    }
}

enum DietRulesEvaluator {
    static func mandatoryBlocks(
        global: GlobalMealPlanningRules,
        profile: DietProfile,
        for slot: MealSlot
    ) -> [[String]] {
        var blocks: [[String]] = []

        let globalSlot = global.rules(for: slot)
        if !globalSlot.mandatoryCategoryIDs.isEmpty {
            blocks.append(globalSlot.mandatoryCategoryIDs)
        }

        if !profile.mandatoryCategoryIDs.isEmpty {
            blocks.append(profile.mandatoryCategoryIDs)
        }

        if profile.usesSlotRules(for: slot) {
            let slotMandatory = profile.mandatoryCategoryIDs(for: slot)
            if !slotMandatory.isEmpty {
                blocks.append(slotMandatory)
            }
        }

        return blocks
    }

    static func forbiddenCategoryIDs(
        global: GlobalMealPlanningRules,
        profile: DietProfile,
        for slot: MealSlot
    ) -> Set<String> {
        var forbidden = Set(global.allMealsForbiddenCategoryIDs)
        forbidden.formUnion(global.rules(for: slot).forbiddenCategoryIDs)
        forbidden.formUnion(profile.forbiddenCategoryIDs)

        if profile.usesSlotRules(for: slot) {
            forbidden.formUnion(profile.forbiddenCategoryIDs(for: slot))
        }

        return forbidden
    }

    static func recipeMatches(
        tags: Set<String>,
        mandatoryBlocks: [[String]],
        forbidden: Set<String>
    ) -> Bool {
        guard tags.isDisjoint(with: forbidden) else { return false }

        for block in mandatoryBlocks where !block.isEmpty {
            if Set(block).isDisjoint(with: tags) {
                return false
            }
        }

        return true
    }
}

extension DietProfile {
    func usesSlotRules(for slot: MealSlot) -> Bool {
        switch slot {
        case .breakfast: usesBreakfastSlotRules
        case .lunch: usesLunchSlotRules
        case .dinner: usesDinnerSlotRules
        }
    }

    func mandatoryCategoryIDs(for slot: MealSlot) -> [String] {
        switch slot {
        case .breakfast: breakfastMandatoryCategoryIDs
        case .lunch: lunchMandatoryCategoryIDs
        case .dinner: dinnerMandatoryCategoryIDs
        }
    }

    func forbiddenCategoryIDs(for slot: MealSlot) -> [String] {
        switch slot {
        case .breakfast: breakfastForbiddenCategoryIDs
        case .lunch: lunchForbiddenCategoryIDs
        case .dinner: dinnerForbiddenCategoryIDs
        }
    }

    func setUsesSlotRules(_ enabled: Bool, for slot: MealSlot) {
        switch slot {
        case .breakfast: usesBreakfastSlotRules = enabled
        case .lunch: usesLunchSlotRules = enabled
        case .dinner: usesDinnerSlotRules = enabled
        }
    }

    var requiresCategoryVariety: Bool {
        !mandatoryCategoryIDs.isEmpty
    }
}
