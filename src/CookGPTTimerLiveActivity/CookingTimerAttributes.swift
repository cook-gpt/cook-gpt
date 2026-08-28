//  CookingTimerAttributes.swift
//  CookGPT
//
//  ActivityAttributes payload for the timer Live Activity widget.
//
//  Keep in sync with src/CookGPT/LiveActivity/CookingTimerAttributes.swift.
//

import ActivityKit
import Foundation

struct CookingTimerAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var stepID: String
        var recipeTitle: String
        var stepLabel: String
        var phase: String
        var endsAt: Date?
        var remainingSeconds: Int
    }

    var timerID: String
}
