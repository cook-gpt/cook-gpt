//  CookingTimerAttributes.swift
//  Cook GPT
//
//  ActivityAttributes payload for the timer Live Activity widget.
//
//  Keep in sync with Cook GPT/LiveActivity/CookingTimerAttributes.swift.
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
