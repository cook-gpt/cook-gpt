//  ModelContainer+CookGPT.swift
//  Cook GPT
//
//  SwiftData schema, versioned store URL, legacy migration, and crash recovery.
//

import Foundation
import SwiftData

/// SwiftData persistence: schema definition, versioned store, and recovery.
enum CookGPTModelContainer {
    /// Bump when SwiftData models change incompatibly.
    static let schemaVersion = 6

    private static let seedFlagKey = "didSeedSampleData"
    private static let recipeStructureVersionKey = "sampleRecipeStructureVersion"
    private static let installedStoreVersionKey = "installedStoreSchemaVersion"

    static let schema = Schema([
        Ingredient.self,
        Recipe.self,
        RecipeIngredient.self,
        RecipeStep.self,
        DietProfile.self,
        ScheduledMeal.self,
        GroceryList.self,
        GroceryItem.self,
    ])

    static func make() throws -> ModelContainer {
        migrateFromLegacyDefaultStoreIfNeeded()

        let configuration = ModelConfiguration(
            schema: schema,
            url: storeURL,
            allowsSave: true
        )

        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
            UserDefaults.standard.set(schemaVersion, forKey: installedStoreVersionKey)
            return container
        } catch {
            destroyStoreFiles(at: storeURL)
            resetSeedFlags()

            let container = try ModelContainer(for: schema, configurations: configuration)
            UserDefaults.standard.set(schemaVersion, forKey: installedStoreVersionKey)
            return container
        }
    }

    private static var storeURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("CookGPT", isDirectory: true)
        try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        return appDirectory.appendingPathComponent("CookGPT-schema-v\(schemaVersion).store")
    }

    /// Earlier builds used SwiftData's implicit default store path.
    private static func migrateFromLegacyDefaultStoreIfNeeded() {
        let installedVersion = UserDefaults.standard.integer(forKey: installedStoreVersionKey)
        guard installedVersion < schemaVersion else { return }

        guard let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return
        }

        let legacyStore = appSupport.appendingPathComponent("default.store")
        destroyStoreFiles(at: legacyStore)
        resetSeedFlags()
    }

    private static func destroyStoreFiles(at url: URL) {
        let fileManager = FileManager.default
        let basePath = url.path

        for path in [basePath, "\(basePath)-shm", "\(basePath)-wal"] {
            if fileManager.fileExists(atPath: path) {
                try? fileManager.removeItem(atPath: path)
            }
        }
    }

    private static func resetSeedFlags() {
        UserDefaults.standard.removeObject(forKey: seedFlagKey)
        UserDefaults.standard.removeObject(forKey: recipeStructureVersionKey)
    }
}
