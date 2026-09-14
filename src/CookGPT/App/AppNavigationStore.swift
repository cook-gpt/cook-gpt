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
    private(set) var recipeIDsPendingDeletion: Set<UUID> = []
    private(set) var mealIDsPendingDeletion: Set<UUID> = []
    /// Meal IDs removed from the schedule. Kept for the session so stale @Query rows are never rendered.
    private(set) var hiddenMealIDs: Set<UUID> = []
    private(set) var mealSlotByMealID: [UUID: MealSlot] = [:]
    private(set) var mealSlotLabelByMealID: [UUID: String] = [:]
    private(set) var mealSlotDisplayOrderByMealID: [UUID: Int] = [:]
    private(set) var mealScheduleSyncToken = 0

    private init() {}

    func notifyMealScheduleChanged() {
        mealScheduleSyncToken += 1
    }

    func beginRecipeDeletion(recipeID: UUID, mealSnapshots: [ScheduledMealDeletionSnapshot]) {
        recipeIDsPendingDeletion.insert(recipeID)

        for snapshot in mealSnapshots {
            mealIDsPendingDeletion.insert(snapshot.id)
            hiddenMealIDs.insert(snapshot.id)
            mealSlotByMealID[snapshot.id] = snapshot.mealSlot
            mealSlotLabelByMealID[snapshot.id] = snapshot.label
            mealSlotDisplayOrderByMealID[snapshot.id] = snapshot.displayOrder
        }
    }

    func endRecipeDeletion(recipeID: UUID) {
        recipeIDsPendingDeletion.remove(recipeID)
    }

    func registerDeletedMealIDs(_ mealIDs: Set<UUID>) {
        hiddenMealIDs.formUnion(mealIDs)
        mealIDsPendingDeletion.formUnion(mealIDs)
    }

    func pruneDeletedMeals(stillPresentMealIDs: Set<UUID>) {
        let deletedMealIDs = mealIDsPendingDeletion.subtracting(stillPresentMealIDs)
        guard !deletedMealIDs.isEmpty else { return }
        mealIDsPendingDeletion.subtract(deletedMealIDs)
    }

    func cacheMealSlotsIfNeeded(from meals: [ScheduledMeal], trustedMealIDs: Set<UUID>) {
        for meal in meals {
            guard trustedMealIDs.contains(meal.id) else { continue }
            guard !hiddenMealIDs.contains(meal.id) else { continue }
            guard mealSlotByMealID[meal.id] == nil else { continue }
            cacheMealSlot(from: meal)
        }
    }

    func cacheMealSlot(from meal: ScheduledMeal) {
        guard !hiddenMealIDs.contains(meal.id) else { return }

        mealSlotByMealID[meal.id] = meal.mealSlot
        mealSlotLabelByMealID[meal.id] = meal.mealSlot.label
        mealSlotDisplayOrderByMealID[meal.id] = meal.mealSlot.displayOrder
    }

    func mealSlotLabel(for mealID: UUID) -> String {
        mealSlotLabelByMealID[mealID] ?? MealSlot.lunch.label
    }

    func mealSlot(for mealID: UUID) -> MealSlot {
        mealSlotByMealID[mealID] ?? .lunch
    }

    func mealSlotDisplayOrder(for mealID: UUID) -> Int {
        mealSlotDisplayOrderByMealID[mealID] ?? MealSlot.lunch.displayOrder
    }

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
        recipeIDsPendingDeletion = []
        mealIDsPendingDeletion = []
        hiddenMealIDs = []
        mealSlotByMealID = [:]
        mealSlotLabelByMealID = [:]
        mealSlotDisplayOrderByMealID = [:]
    }
}
