//  RecipeIngredient.swift
//  Cook GPT
//
//  Links a recipe to a catalog ingredient with quantity and unit.
//

import Foundation
import SwiftData

/// Quantity of an ingredient used by a recipe.
@Model
final class RecipeIngredient {
    var quantity: Double
    var unit: String
    var ingredient: Ingredient?
    var recipe: Recipe?

    init(quantity: Double, unit: String, ingredient: Ingredient? = nil, recipe: Recipe? = nil) {
        self.quantity = quantity
        self.unit = unit
        self.ingredient = ingredient
        self.recipe = recipe
    }

    var displayName: String {
        ingredient?.name ?? "Ingredient"
    }
}
