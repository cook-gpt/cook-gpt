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
