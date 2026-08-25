import Foundation
import SwiftData

@Model
final class PantryItem {
    var name: String
    var quantity: Double
    var unit: String
    var expiresOn: Date?
    var ingredient: Ingredient?

    init(
        name: String,
        quantity: Double,
        unit: String,
        expiresOn: Date? = nil,
        ingredient: Ingredient? = nil
    ) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.expiresOn = expiresOn
        self.ingredient = ingredient
    }
}
