import Foundation
import SwiftData

@Model
final class RecipeStep {
    var id: UUID
    var order: Int
    var instruction: String
    var timerSeconds: Int?
    var recipe: Recipe?

    init(
        id: UUID = UUID(),
        order: Int,
        instruction: String,
        timerSeconds: Int? = nil,
        recipe: Recipe? = nil
    ) {
        self.id = id
        self.order = order
        self.instruction = instruction
        self.timerSeconds = timerSeconds
        self.recipe = recipe
    }

    var displayLabel: String {
        instruction.split(separator: " ").prefix(4).joined(separator: " ")
    }
}
