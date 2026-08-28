//  Ingredient.swift
//  CookGPT
//
//  Reusable ingredient catalog entry.
//

import Foundation
import SwiftData

/// Named ingredient in the shared catalog.
@Model
final class Ingredient {
    var id: UUID
    var name: String
    var category: IngredientCategory

    init(id: UUID = UUID(), name: String, category: IngredientCategory) {
        self.id = id
        self.name = name
        self.category = category
    }
}
