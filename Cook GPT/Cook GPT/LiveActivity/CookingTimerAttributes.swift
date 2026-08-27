//  CookingTimerAttributes.swift
//  Cook GPT
//
//  ActivityAttributes payload shared with the widget extension.
//
//  Keep in sync with CookGPTTimerLiveActivity/CookingTimerAttributes.swift.
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
