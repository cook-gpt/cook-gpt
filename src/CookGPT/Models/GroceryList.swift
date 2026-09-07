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
        nextSortOrder(isChecked: false)
    }

    func nextSortOrder(isChecked: Bool, excluding excludedItem: GroceryItem? = nil) -> Int {
        let group = items.filter {
            $0.isChecked == isChecked && $0.persistentModelID != excludedItem?.persistentModelID
        }
        return (group.map(\.sortOrder).max() ?? -1) + 1
    }

    func normalizePartitionedSortOrders() {
        let checked = items.filter(\.isChecked).sorted { $0.sortOrder < $1.sortOrder }
        let unchecked = items.filter { !$0.isChecked }.sorted { $0.sortOrder < $1.sortOrder }

        for (index, item) in checked.enumerated() {
            item.sortOrder = index
        }
        for (index, item) in unchecked.enumerated() {
            item.sortOrder = index
        }
    }

    var displayOrderedItems: [GroceryItem] {
        let checked = items.filter(\.isChecked).sorted { $0.sortOrder < $1.sortOrder }
        let unchecked = items.filter { !$0.isChecked }.sorted { $0.sortOrder < $1.sortOrder }
        return checked + unchecked
    }
}
