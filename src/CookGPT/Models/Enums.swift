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
        case .oven: "Oven"
        case .pan: "Pan"
        case .fryer: "Fryer"
        case .airFryer: "Air fryer"
        case .fridge: "Fridge"
        case .freezer: "Freezer"
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
