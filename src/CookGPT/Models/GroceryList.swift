//  GroceryList.swift
//  CookGPT
//
//  Shopping list container with generation metadata.
//

import Foundation
import SwiftData

/// Shopping list with optional generation metadata.
@Model
final class GroceryList {
    var name: String
    var sourceDescription: String
    var generatedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \GroceryItem.list)
    var items: [GroceryItem]

    init(
        name: String,
        sourceDescription: String = "",
        generatedAt: Date? = nil,
        items: [GroceryItem] = []
    ) {
        self.name = name
        self.sourceDescription = sourceDescription
        self.generatedAt = generatedAt
        self.items = items
    }

    var nextGrocerySortOrder: Int {
        (items.map(\.sortOrder).max() ?? -1) + 1
    }
}
