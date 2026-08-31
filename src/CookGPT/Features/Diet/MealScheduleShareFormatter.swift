//  MealScheduleShareFormatter.swift
//  CookGPT
//
//  Plain-text export for sharing scheduled meals in the current range.
//

import Foundation

enum MealScheduleShareFormatter {
    private static let rangeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = MealScheduleCalendar.calendar
        formatter.locale = Locale.current
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private static let dayHeadingFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = MealScheduleCalendar.calendar
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMMM (EEEE)"
        return formatter
    }()

    static func text(
        days: [Date],
        meals: [ScheduledMeal],
        recipes: [Recipe]
    ) -> String {
        guard let rangeStart = days.first, let rangeEnd = days.last else { return "" }

        let recipeTitlesByID = Dictionary(uniqueKeysWithValues: recipes.map { ($0.id, $0.title) })
        var lines: [String] = [
            "Scheduled meals (\(rangeDateFormatter.string(from: rangeStart)) - \(rangeDateFormatter.string(from: rangeEnd)))",
            "",
        ]

        for day in days {
            let dayMeals = meals
                .filter { MealScheduleCalendar.isSameDay($0.day, day) }
                .sortedByMealSlot()
                .compactMap { meal -> (MealSlot, String)? in
                    guard let recipeID = meal.recipeID,
                          let title = recipeTitlesByID[recipeID] else {
                        return nil
                    }
                    return (meal.mealSlot, title)
                }

            guard !dayMeals.isEmpty else { continue }

            lines.append(dayHeading(day))

            for (slot, title) in dayMeals {
                lines.append("- \(slot.label): \(title)")
            }

            lines.append("")
        }

        if lines.last == "" {
            lines.removeLast()
        }

        lines.append("")
        lines.append(AppMetadata.shareAttribution)
        return lines.joined(separator: "\n")
    }

    private static func dayHeading(_ date: Date) -> String {
        dayHeadingFormatter.string(from: date)
    }
}
