//  IngredientUnitFormatting.swift
//  CookGPT
//
//  Localized display labels for ingredient measurement units.
//

import Foundation

enum IngredientUnitFormatting {
    /// Uses singular form only when quantity is exactly 1.
    static func usesSingularForm(for quantity: Double) -> Bool {
        quantity == 1
    }

    /// Quantity-aware label for read-only display (recipe detail, groceries list).
    static func localizedLabel(for unit: String, quantity: Double) -> String {
        switch pluralUnit(for: unit) {
        case .cup:
            return usesSingularForm(for: quantity)
                ? String(localized: "unit_cup.one")
                : String(localized: "unit_cup.other")
        case .piece:
            return usesSingularForm(for: quantity)
                ? String(localized: "unit_piece.one")
                : String(localized: "unit_piece.other")
        case .countableUnit:
            return usesSingularForm(for: quantity)
                ? String(localized: "unit_unit.one")
                : String(localized: "unit_unit.other")
        case nil:
            return localizedStaticLabel(for: unit)
        }
    }

    /// Combined singular/plural label for unit pickers in edit mode.
    static func localizedPickerLabel(for unit: String) -> String {
        switch pluralUnit(for: unit) {
        case .cup:
            String(localized: "unit_cup.picker")
        case .piece:
            String(localized: "unit_piece.picker")
        case .countableUnit:
            String(localized: "unit_unit.picker")
        case nil:
            localizedStaticLabel(for: unit)
        }
    }

    /// Reference label when no quantity is available (e.g. settings unit list).
    static func localizedLabel(for unit: String) -> String {
        localizedPickerLabel(for: unit)
    }

    private enum PluralUnit {
        case cup
        case piece
        case countableUnit
    }

    private static func pluralUnit(for unit: String) -> PluralUnit? {
        switch unit.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "cup", "cups": .cup
        case "piece", "pieces": .piece
        case "unit", "units": .countableUnit
        default: nil
        }
    }

    private static func localizedStaticLabel(for unit: String) -> String {
        switch unit.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "g": String(localized: "g")
        case "mg": String(localized: "mg")
        case "ml": String(localized: "ml")
        case "l": String(localized: "l")
        case "tbsp": String(localized: "tbsp")
        case "tsp": String(localized: "tsp")
        case "oz": String(localized: "oz")
        case "lb": String(localized: "lb")
        case "fl oz": String(localized: "fl oz")
        default: unit
        }
    }
}
