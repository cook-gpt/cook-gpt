//  RecipeShareFormatter.swift
//  CookGPT
//
//  Plain-text export for sharing a recipe.
//

import Foundation

enum RecipeShareFormatter {
    static func text(for recipe: Recipe, servings: Int) -> String {
        var lines: [String] = [
            recipe.title,
            "- \(servings) servings",
            "- \(recipe.prepMinutes) min prep time",
            "- \(recipe.cookMinutes) min cooking time",
            "",
            "Ingredients:",
        ]

        if recipe.ingredients.isEmpty {
            lines.append("- (none)")
        } else {
            for item in recipe.ingredients {
                let scaled = recipe.scaledQuantity(item.quantity, servings: servings)
                lines.append(ingredientLine(quantity: scaled, unit: item.unit, name: item.displayName))
            }
        }

        lines.append("")
        lines.append("Steps:")

        if recipe.sortedSteps.isEmpty {
            lines.append("- (none)")
        } else {
            for (index, step) in recipe.sortedSteps.enumerated() {
                lines.append("- \(index + 1). \(step.instruction)")
            }
        }

        lines.append("")
        lines.append("Made with CookGPT")
        return lines.joined(separator: "\n")
    }

    private static func ingredientLine(quantity: Double, unit: String, name: String) -> String {
        let quantityText = QuantityFormatter.string(quantity)
        let unitText = unit.trimmingCharacters(in: .whitespacesAndNewlines)
        let compactUnits: Set<String> = ["g", "kg", "ml", "l"]

        if compactUnits.contains(unitText.lowercased()) {
            return "- \(quantityText)\(unitText.lowercased()) of \(name)"
        }

        if unitText.isEmpty {
            return "- \(quantityText) of \(name)"
        }

        return "- \(quantityText) \(unitText) of \(name)"
    }
}
