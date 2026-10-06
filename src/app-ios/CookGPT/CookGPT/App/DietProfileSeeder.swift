//  DietProfileSeeder.swift
//  CookGPT
//
//  Seeds built-in diet profiles when none exist.
//

import Foundation
import SwiftData

enum DietProfileSeeder {
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<DietProfile>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        for profile in DietProfile.defaultPresets() {
            context.insert(profile)
        }

        try? context.save()
    }
}
