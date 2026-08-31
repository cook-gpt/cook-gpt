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

    var selectedTab: Tab = .recipes
    private(set) var highlightedGroceryItemKeys: Set<String> = []

    private init() {}

    func openGroceries(highlightingItemKeys keys: Set<String>) {
        highlightedGroceryItemKeys = keys
        selectedTab = .groceries
    }

    func clearGroceryHighlights() {
        highlightedGroceryItemKeys = []
    }

    func reset() {
        selectedTab = .recipes
        highlightedGroceryItemKeys = []
    }
}
