//  CookingSessionManager.swift
//  Cook GPT
//
//  App-wide facade for active cooking timers.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class CookingSessionManager {
    static let shared = CookingSessionManager()

    let timerStore = CookingTimerStore()

    private init() {
        timerStore.loadPersisted()
    }

    func isInProgress(recipe: Recipe) -> Bool {
        !timerStore.timers(for: recipe.id).isEmpty
    }

    func reset() {
        timerStore.clearAll()
    }
}
