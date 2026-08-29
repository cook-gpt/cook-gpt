//  GroceryListShareFormatter.swift
//  CookGPT
//
//  Plain-text export for sharing a grocery list.
//

import Foundation

enum GroceryListShareFormatter {
    static func text(listName: String, items: [GroceryItem]) -> String {
        var lines: [String] = [
            listName,
            "",
            "Ingredients:",
        ]

        if items.isEmpty {
            lines.append("- (none)")
        } else {
            for item in items {
                lines.append(ingredientLine(quantity: item.quantity, unit: item.unit, name: item.name))
            }
        }

        lines.append("")
        lines.append(AppMetadata.shareAttribution)
        return lines.joined(separator: "\n")
    }

    private static func ingredientLine(quantity: Double, unit: String, name: String) -> String {
        let quantityText = QuantityFormatter.string(quantity)
        let unitText = unit.trimmingCharacters(in: .whitespacesAndNewlines)
        let compactUnits: Set<String> = ["g", "mg", "ml", "l"]

        if compactUnits.contains(unitText.lowercased()) {
            return "- \(quantityText)\(unitText.lowercased()) of \(name)"
        }

        if unitText.isEmpty {
            return "- \(quantityText) of \(name)"
        }

        return "- \(quantityText) \(unitText) of \(name)"
    }
}
