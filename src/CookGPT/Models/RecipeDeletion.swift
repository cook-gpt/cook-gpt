//  RecipeDeletion.swift
//  CookGPT
//
//  Coordinated recipe deletion that removes planned meals first, then the recipe.
//

import Foundation
import SwiftData

struct ScheduledMealDeletionSnapshot: Sendable {
    let id: UUID
    let mealSlot: MealSlot
    let displayOrder: Int
    let label: String
}

enum RecipeDeletion {
    @MainActor
    static func mealSnapshots(for recipeID: UUID, in context: ModelContext) -> [ScheduledMealDeletionSnapshot] {
        let predicate = #Predicate<ScheduledMeal> { $0.recipeID == recipeID }
        let meals = (try? context.fetch(FetchDescriptor(predicate: predicate))) ?? []

        return meals.map { meal in
            ScheduledMealDeletionSnapshot(
                id: meal.id,
                mealSlot: meal.mealSlot,
                displayOrder: meal.mealSlot.displayOrder,
                label: meal.mealSlot.label
            )
        }
    }

    @MainActor
    static func deleteRecipe(id recipeID: UUID, in context: ModelContext) {
        let predicate = #Predicate<ScheduledMeal> { $0.recipeID == recipeID }
        if let meals = try? context.fetch(FetchDescriptor(predicate: predicate)) {
            for meal in meals {
                context.delete(meal)
            }
        }

        let recipePredicate = #Predicate<Recipe> { $0.id == recipeID }
        var recipeDescriptor = FetchDescriptor<Recipe>(predicate: recipePredicate)
        recipeDescriptor.fetchLimit = 1

        if let recipe = try? context.fetch(recipeDescriptor).first {
            context.delete(recipe)
        }

        try? context.save()
    }

    @MainActor
    static func presentMealIDs(in context: ModelContext) -> Set<UUID> {
        let meals = (try? context.fetch(FetchDescriptor<ScheduledMeal>())) ?? []
        return Set(meals.map(\.id))
    }
}

@MainActor
@Observable
final class RecipeDeletionCoordinator {
    static let shared = RecipeDeletionCoordinator()

    private var pipeline: Task<Void, Never>?

    private init() {}

    func deleteRecipe(
        id recipeID: UUID,
        navigation: AppNavigationStore,
        context: ModelContext,
        onWillHide: () -> Void,
        onDidFinish: @escaping (UUID) -> Void
    ) {
        let mealSnapshots = RecipeDeletion.mealSnapshots(for: recipeID, in: context)
        navigation.beginRecipeDeletion(recipeID: recipeID, mealSnapshots: mealSnapshots)
        navigation.notifyMealScheduleChanged()
        onWillHide()

        let work = Task { @MainActor in
            await Task.yield()
            await Task.yield()
            try? await Task.sleep(for: .milliseconds(350))

            RecipeDeletion.deleteRecipe(id: recipeID, in: context)

            await Task.yield()
            try? await Task.sleep(for: .milliseconds(150))

            navigation.endRecipeDeletion(recipeID: recipeID)
            let presentMealIDs = RecipeDeletion.presentMealIDs(in: context)
            navigation.pruneDeletedMeals(stillPresentMealIDs: presentMealIDs)
            navigation.notifyMealScheduleChanged()
            onDidFinish(recipeID)
        }

        if let pipeline {
            self.pipeline = Task {
                await pipeline.value
                await work.value
            }
        } else {
            pipeline = work
        }
    }
}
