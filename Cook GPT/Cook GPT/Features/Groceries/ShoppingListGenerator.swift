import Foundation

struct AggregatedGroceryItem: Identifiable, Hashable {
    let id: String
    let name: String
    let unit: String
    let quantity: Double

    var key: String {
        "\(name.lowercased())|\(unit.lowercased())"
    }
}

enum ShoppingListGenerator {
    static func aggregate(recipes: [(recipe: Recipe, servings: Int)]) -> [AggregatedGroceryItem] {
        var totals: [String: (name: String, unit: String, quantity: Double)] = [:]

        for entry in recipes {
            guard entry.servings > 0, entry.recipe.servings > 0 else { continue }

            for item in entry.recipe.ingredients {
                let scaled = entry.recipe.scaledQuantity(item.quantity, servings: entry.servings)
                let name = item.displayName
                let unit = item.unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : item.unit
                let key = "\(name.lowercased())|\(unit.lowercased())"

                if var existing = totals[key] {
                    existing.quantity += scaled
                    totals[key] = existing
                } else {
                    totals[key] = (name: name, unit: unit, quantity: scaled)
                }
            }
        }

        return totals.values
            .map { AggregatedGroceryItem(id: "\($0.name)|\($0.unit)", name: $0.name, unit: $0.unit, quantity: $0.quantity) }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    static func recipes(from meals: [ScheduledMeal]) -> [(recipe: Recipe, servings: Int)] {
        meals.compactMap { meal in
            guard let recipe = meal.recipe else { return nil }
            return (recipe: recipe, servings: meal.servings)
        }
    }

    static func sourceLabel(for scope: ShoppingListScope, start: Date, end: Date) -> String {
        switch scope {
        case .today:
            return "Scheduled meals for \(MealScheduleCalendar.dayTitle(start))"
        case .week:
            return "Scheduled meals for \(MealScheduleCalendar.weekRangeTitle(containing: start))"
        case .month:
            return "Scheduled meals for \(MealScheduleCalendar.monthTitle(for: start))"
        case .custom:
            let startText = start.formatted(date: .abbreviated, time: .omitted)
            let endText = end.formatted(date: .abbreviated, time: .omitted)
            return "Scheduled meals for \(startText) – \(endText)"
        }
    }

    static func recipesLabel(count: Int) -> String {
        count == 1 ? "1 selected recipe" : "\(count) selected recipes"
    }
}
