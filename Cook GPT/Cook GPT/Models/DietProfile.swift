//  DietProfile.swift
//  Cook GPT
//
//  Active diet profile used by meal planning.
//

import Foundation
import SwiftData

/// User diet profile for meal planning filters.
@Model
final class DietProfile {
    var name: String
    var dietType: DietType
    var isActive: Bool

    init(
        name: String,
        dietType: DietType,
        isActive: Bool = false
    ) {
        self.name = name
        self.dietType = dietType
        self.isActive = isActive
    }
}
