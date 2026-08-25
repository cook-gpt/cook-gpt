import Foundation
import SwiftData

@Model
final class GroceryList {
    var name: String

    @Relationship(deleteRule: .cascade, inverse: \GroceryItem.list)
    var items: [GroceryItem]

    init(name: String, items: [GroceryItem] = []) {
        self.name = name
        self.items = items
    }
}
