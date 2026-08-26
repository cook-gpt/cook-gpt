import Foundation
import SwiftData

@Model
final class Recipe {
    var id: UUID
    var title: String
    var summary: String
    var servings: Int
    var prepMinutes: Int
    var cookMinutes: Int
    var difficulty: RecipeDifficulty
    var tags: [String]
    var isFavorite: Bool

    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.recipe)
    var ingredients: [RecipeIngredient]

    @Relationship(deleteRule: .cascade, inverse: \RecipeStep.recipe)
    var steps: [RecipeStep]

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        servings: Int,
        prepMinutes: Int,
        cookMinutes: Int,
        difficulty: RecipeDifficulty,
        tags: [String] = [],
        isFavorite: Bool = false,
        ingredients: [RecipeIngredient] = [],
        steps: [RecipeStep] = []
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.servings = servings
        self.prepMinutes = prepMinutes
        self.cookMinutes = cookMinutes
        self.difficulty = difficulty
        self.tags = tags
        self.isFavorite = isFavorite
        self.ingredients = ingredients
        self.steps = steps
    }

    var totalMinutes: Int {
        prepMinutes + cookMinutes
    }

    var sortedSteps: [RecipeStep] {
        steps.sorted { $0.order < $1.order }
    }

    func scaledQuantity(_ baseQuantity: Double, servings: Int) -> Double {
        guard servings > 0, self.servings > 0 else { return baseQuantity }
        return baseQuantity * Double(servings) / Double(self.servings)
    }

    func hasCategory(_ categoryID: String) -> Bool {
        tags.contains(categoryID)
    }

    func setCategory(_ categoryID: String, enabled: Bool) {
        if enabled {
            guard !hasCategory(categoryID) else { return }
            tags.append(categoryID)
        } else {
            tags.removeAll { $0 == categoryID }
        }
    }
}
