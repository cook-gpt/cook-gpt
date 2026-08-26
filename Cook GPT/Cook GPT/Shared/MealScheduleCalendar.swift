import Foundation

enum MealScheduleCalendar {
    static let calendar = Calendar.current

    static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    static func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }

    static func daysInWeek(containing date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: date) else { return [] }
        var days: [Date] = []
        var current = startOfDay(interval.start)
        let end = startOfDay(interval.end.addingTimeInterval(-1))

        while current <= end {
            days.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }

        return days
    }

    static func daysInMonth(containing date: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: date),
            let dayCount = calendar.range(of: .day, in: .month, for: date)?.count
        else { return [] }

        return (0..<dayCount).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: monthInterval.start)
        }
    }

    static func monthTitle(for date: Date) -> String {
        date.formatted(.dateTime.month(.wide).year())
    }

    static func dayTitle(_ date: Date) -> String {
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    static func weekRangeTitle(containing date: Date) -> String {
        let days = daysInWeek(containing: date)
        guard let first = days.first, let last = days.last else { return "" }
        return "\(first.formatted(date: .abbreviated, time: .omitted)) – \(last.formatted(date: .abbreviated, time: .omitted))"
    }

    static func dateRange(for scope: ShoppingListScope, referenceDate: Date, customStart: Date, customEnd: Date) -> (start: Date, end: Date) {
        switch scope {
        case .today:
            let day = startOfDay(referenceDate)
            return (day, day)
        case .week:
            let days = daysInWeek(containing: referenceDate)
            return (days.first ?? startOfDay(referenceDate), days.last ?? startOfDay(referenceDate))
        case .month:
            let days = daysInMonth(containing: referenceDate)
            return (days.first ?? startOfDay(referenceDate), days.last ?? startOfDay(referenceDate))
        case .custom:
            let start = startOfDay(min(customStart, customEnd))
            let end = startOfDay(max(customStart, customEnd))
            return (start, end)
        }
    }

    static func dates(from start: Date, through end: Date) -> [Date] {
        var dates: [Date] = []
        var current = startOfDay(start)
        let final = startOfDay(end)

        while current <= final {
            dates.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }

        return dates
    }
}
