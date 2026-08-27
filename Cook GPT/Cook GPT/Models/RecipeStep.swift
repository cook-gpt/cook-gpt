//  RecipeStep.swift
//  Cook GPT
//
//  Ordered cooking step with optional timer duration.
//

import Foundation
import SwiftData

/// One ordered step in a recipe, optionally with a timer.
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
