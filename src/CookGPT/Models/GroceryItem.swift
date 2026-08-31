//  GroceryItem.swift
//  CookGPT
//
//  Line item on a grocery list (name, quantity, unit, checked state).
//

import Foundation
import SwiftData

/// One line on a grocery list.
@Model
final class GroceryItem {
    var name: String
    var quantity: Double
    var unit: String
    var isChecked: Bool
    var sortOrder: Int
    var list: GroceryList?

    init(
        name: String,
        quantity: Double,
        unit: String,
        isChecked: Bool = false,
        sortOrder: Int = 0,
        list: GroceryList? = nil
    ) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.isChecked = isChecked
        self.sortOrder = sortOrder
        self.list = list
    }

    var mergeKey: String {
        let normalizedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : unit
        return "\(name.lowercased())|\(normalizedUnit.lowercased())"
    }
}
