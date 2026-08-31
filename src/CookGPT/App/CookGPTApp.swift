//  CookGPTApp.swift
//  CookGPT
//
//  Application entry point: SwiftData container, environment objects, and first-launch seeding.
//

import SwiftUI
import SwiftData

/// CookGPT application entry point.
@main
struct CookGPTApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try CookGPTModelContainer.make()
        } catch {
            fatalError("Failed to create model container after recovery: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(CookingSessionManager.shared)
                .environment(AppSettingsStore.shared)
                .environment(AppNavigationStore.shared)
                .onAppear {
                    let context = modelContainer.mainContext
                    SampleDataSeeder.seedIfNeeded(context: context)

                    let recipeDescriptor = FetchDescriptor<Recipe>()
                    let recipes = (try? context.fetch(recipeDescriptor)) ?? []
                    ScheduledMeal.removeOrphanedMeals(
                        validRecipeIDs: Set(recipes.map(\.id)),
                        in: context
                    )
                }
        }
        .modelContainer(modelContainer)
    }
}
