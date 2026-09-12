//  AppNavigationStore.swift
//  CookGPT
//
//  Root tab selection and cross-tab navigation cues.
//

import Foundation

@Observable
@MainActor
final class AppNavigationStore {
    static let shared = AppNavigationStore()

    enum Tab: Hashable {
        case recipes
        case meals
        case groceries
        case settings
    }

    struct RecipeScrollRequest: Equatable {
        let recipeID: UUID
        let stepID: UUID?
    }

    var selectedTab: Tab = .recipes
    private(set) var highlightedGroceryItemKeys: Set<String> = []
    private(set) var pendingRecipeNavigationID: UUID?
    private(set) var pendingRecipeScrollRequest: RecipeScrollRequest?

    private init() {}

    func openGroceries(highlightingItemKeys keys: Set<String>) {
        highlightedGroceryItemKeys = keys
        selectedTab = .groceries
    }

    func openRecipe(id: UUID, stepID: UUID? = nil) {
        selectedTab = .recipes
        pendingRecipeNavigationID = id
        pendingRecipeScrollRequest = RecipeScrollRequest(recipeID: id, stepID: stepID)
    }

    func consumePendingRecipeNavigation() -> UUID? {
        let recipeID = pendingRecipeNavigationID
        pendingRecipeNavigationID = nil
        return recipeID
    }

    func consumePendingRecipeScrollRequest(for recipeID: UUID) -> RecipeScrollRequest? {
        guard let request = pendingRecipeScrollRequest, request.recipeID == recipeID else {
            return nil
        }
        pendingRecipeScrollRequest = nil
        return request
    }

    func clearGroceryHighlights() {
        highlightedGroceryItemKeys = []
    }

    func reset() {
        selectedTab = .recipes
        highlightedGroceryItemKeys = []
        pendingRecipeNavigationID = nil
        pendingRecipeScrollRequest = nil
    }
}
