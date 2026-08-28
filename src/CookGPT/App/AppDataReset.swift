//  AppDataReset.swift
//  CookGPT
//
//  Factory reset: clears SwiftData, settings, timers, and re-seeds sample content.
//

import Foundation
import SwiftData

@MainActor
enum AppDataReset {
    static func resetToDefaults(
        context: ModelContext,
        settings: AppSettingsStore,
        cookingSession: CookingSessionManager
    ) async {
        cookingSession.reset()
        await CookingTimerLiveActivityManager.endAll()

        settings.beginDataReset()
        await Task.yield()

        deleteAllData(context: context)
        settings.resetToDefaults()
        SampleDataSeeder.resetInstallFlags()
        SampleDataSeeder.seedFreshInstall(context: context)
        try? context.save()

        settings.endDataReset()
    }

    private static func deleteAllData(context: ModelContext) {
        deleteAll(ScheduledMeal.self, context: context)
        deleteAll(GroceryItem.self, context: context)
        deleteAll(GroceryList.self, context: context)
        deleteAll(RecipeStep.self, context: context)
        deleteAll(RecipeIngredient.self, context: context)
        deleteAll(Recipe.self, context: context)
        deleteAll(Ingredient.self, context: context)
        deleteAll(DietProfile.self, context: context)
        try? context.save()
    }

    private static func deleteAll<T: PersistentModel>(_ type: T.Type, context: ModelContext) {
        let descriptor = FetchDescriptor<T>()
        let items = (try? context.fetch(descriptor)) ?? []
        items.forEach { context.delete($0) }
    }
}
