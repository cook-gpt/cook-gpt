//  ShoppingListGenerator.swift
//  CookGPT
//
//  Scales and aggregates recipe ingredients into grocery lines.
//

import Foundation

struct AggregatedGroceryItem: Identifiable, Hashable {
    let id: String
    let name: String
    let unit: String
    let quantity: Double
    let isChecked: Bool

    init(id: String, name: String, unit: String, quantity: Double, isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.unit = unit
        self.quantity = quantity
        self.isChecked = isChecked
    }

    var key: String {
        ShoppingListGenerator.mergeKey(name: name, unit: unit, isChecked: isChecked)
    }

    /// Display/highlight identity (name + unit), independent of checked state.
    var identityKey: String {
        let normalizedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : unit
        return "\(name.lowercased())|\(normalizedUnit.lowercased())"
    }
}

/// Scales recipe ingredients and merges grocery lines by name, unit, and checked state.
enum ShoppingListGenerator {
    private struct ItemTotal {
        var name: String
        var unit: String
        var quantity: Double
        var isChecked: Bool
    }

    static func mergeKey(name: String, unit: String, isChecked: Bool) -> String {
        let normalizedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : unit
        return "\(name.lowercased())|\(normalizedUnit.lowercased())|\(isChecked)"
    }

    private static func mergeKey(name: String, unit: String) -> String {
        let normalizedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : unit
        return "\(name.lowercased())|\(normalizedUnit.lowercased())"
    }

    static func aggregate(recipes: [(recipe: Recipe, servings: Int)]) -> [AggregatedGroceryItem] {
        var totals: [String: ItemTotal] = [:]

        for entry in recipes {
            guard entry.servings > 0, entry.recipe.servings > 0 else { continue }

            for item in entry.recipe.ingredients {
                let scaled = entry.recipe.scaledQuantity(item.quantity, servings: entry.servings)
                let name = item.displayName
                let unit = item.unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : item.unit
                let key = mergeKey(name: name, unit: unit)

                if var existing = totals[key] {
                    existing.quantity += scaled
                    totals[key] = existing
                } else {
                    totals[key] = ItemTotal(name: name, unit: unit, quantity: scaled, isChecked: false)
                }
            }
        }

        return totals.values
            .map {
                AggregatedGroceryItem(
                    id: "\($0.name)|\($0.unit)",
                    name: $0.name,
                    unit: $0.unit,
                    quantity: $0.quantity,
                    isChecked: $0.isChecked
                )
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    static func merge(
        aggregated newItems: [AggregatedGroceryItem],
        with existingItems: [GroceryItem]
    ) -> [AggregatedGroceryItem] {
        var totals: [String: ItemTotal] = [:]

        for item in existingItems {
            let unit = item.unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "g" : item.unit
            let key = mergeKey(name: item.name, unit: unit, isChecked: item.isChecked)
            if var existing = totals[key] {
                existing.quantity += item.quantity
                totals[key] = existing
            } else {
                totals[key] = ItemTotal(
                    name: item.name,
                    unit: unit,
                    quantity: item.quantity,
                    isChecked: item.isChecked
                )
            }
        }

        for item in newItems {
            let key = mergeKey(name: item.name, unit: item.unit, isChecked: false)
            if var existing = totals[key] {
                existing.quantity += item.quantity
                totals[key] = existing
            } else {
                totals[key] = ItemTotal(
                    name: item.name,
                    unit: item.unit,
                    quantity: item.quantity,
                    isChecked: false
                )
            }
        }

        return totals.values
            .map {
                AggregatedGroceryItem(
                    id: "\($0.name)|\($0.unit)",
                    name: $0.name,
                    unit: $0.unit,
                    quantity: $0.quantity,
                    isChecked: $0.isChecked
                )
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    static func recipes(
        from meals: [ScheduledMeal],
        allRecipes: [Recipe]
    ) -> [(recipe: Recipe, servings: Int)] {
        meals.compactMap { meal in
            guard let recipeID = meal.recipeID,
                  let recipe = allRecipes.first(where: { $0.id == recipeID }) else {
                return nil
            }
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
