import Foundation
import SwiftData

@Model
final class DietProfile {
    var name: String
    var dietType: DietType
    var isActive: Bool

    init(
        name: String,
        dietType: DietType,
        isActive: Bool = false
    ) {
        self.name = name
        self.dietType = dietType
        self.isActive = isActive
    }
}
