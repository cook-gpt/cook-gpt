//  Enums.swift
//  CookGPT
//
//  Shared recipe and ingredient enums (difficulty, categories).
//

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
        switch self {
        case .easy: String(localized: "Easy")
        case .medium: String(localized: "Medium")
        case .hard: String(localized: "Hard")
        }
    }

    var sortOrder: Int {
        switch self {
        case .easy: 0
        case .medium: 1
        case .hard: 2
        }
    }
}

enum RecipeCookingTool: String, Codable, CaseIterable, Identifiable {
    case oven
    case pan
    case fryer
    case airFryer
    case fridge
    case freezer

    var id: String { rawValue }

    var label: String {
        switch self {
        case .oven: String(localized: "Oven")
        case .pan: String(localized: "Pan")
        case .fryer: String(localized: "Fryer")
        case .airFryer: String(localized: "Air fryer")
        case .fridge: String(localized: "Fridge")
        case .freezer: String(localized: "Freezer")
        }
    }

    var systemImage: String {
        switch self {
        case .oven: "oven.fill"
        case .pan: "frying.pan.fill"
        case .fryer: "flame.fill"
        case .airFryer: "wind"
        case .fridge: "refrigerator.fill"
        case .freezer: "snowflake"
        }
    }
}
