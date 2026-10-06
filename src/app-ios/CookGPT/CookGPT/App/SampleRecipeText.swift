//  SampleRecipeText.swift
//  CookGPT
//
//  Localized copy for bundled starter recipes seeded during onboarding.
//

import Foundation

enum SampleRecipeText {
    static func localized(_ english: String) -> String {
        String(localized: String.LocalizationValue(english))
    }
}
