//  AppSettingsStore.swift
//  Cook GPT
//
//  UserDefaults-backed app preferences (theme, planner, timers, categories, units).
//

import Foundation

struct AppCategory: Identifiable, Codable, Hashable {
    let id: String
    let label: String
    let isDefault: Bool

    init(id: String, label: String, isDefault: Bool = false) {
        self.id = id
        self.label = label
        self.isDefault = isDefault
    }
}

/// Central store for user preferences persisted in `UserDefaults`.
@Observable
@MainActor
final class AppSettingsStore {
    static let shared = AppSettingsStore()

    static let mealPlannerExcludedCategoryIDs: Set<String> = ["breakfast", "dessert"]

    static let defaultCategories: [AppCategory] = [
        AppCategory(id: "vegan", label: "Vegan", isDefault: true),
        AppCategory(id: "vegetarian", label: "Vegetarian", isDefault: true),
        AppCategory(id: "high-protein", label: "High protein", isDefault: true),
        AppCategory(id: "low-carbs", label: "Low carbs", isDefault: true),
        AppCategory(id: "no-carbs", label: "No carbs", isDefault: true),
        AppCategory(id: "no-fats", label: "No fats", isDefault: true),
        AppCategory(id: "quick", label: "Quick", isDefault: true),
        AppCategory(id: "italian", label: "Italian", isDefault: true),
        AppCategory(id: "meal-prep", label: "Meal prep", isDefault: true),
        AppCategory(id: "breakfast", label: "Breakfast", isDefault: true),
        AppCategory(id: "dessert", label: "Dessert", isDefault: true),
    ]

    static let defaultUnits = ["g", "L", "tbsp", "pieces", "units", "cups"]

    private enum Keys {
        static let appTheme = "appSettings.appTheme"
        static let defaultPlannerServings = "appSettings.defaultPlannerServings"
        static let includeBreakfastInMealPrep = "appSettings.includeBreakfastInMealPrep"
        static let timerAlarmSound = "appSettings.timerAlarmSound"
        static let weekStart = "appSettings.weekStart"
        static let customCategories = "appSettings.customCategories"
        static let customUnits = "appSettings.customUnits"
    }

    var appTheme: AppTheme = .system {
        didSet { UserDefaults.standard.set(appTheme.rawValue, forKey: Keys.appTheme) }
    }

    var defaultPlannerServings: Int {
        didSet { UserDefaults.standard.set(defaultPlannerServings, forKey: Keys.defaultPlannerServings) }
    }

    var includeBreakfastInMealPrep = false {
        didSet { UserDefaults.standard.set(includeBreakfastInMealPrep, forKey: Keys.includeBreakfastInMealPrep) }
    }

    var timerAlarmSound: TimerAlarmSound = .defaultSound {
        didSet {
            UserDefaults.standard.set(timerAlarmSound.rawValue, forKey: Keys.timerAlarmSound)
            TimerAlarmSoundInstaller.ensureInstalled(timerAlarmSound)
        }
    }

    var weekStart: WeekStartSetting = .monday {
        didSet { UserDefaults.standard.set(weekStart.rawValue, forKey: Keys.weekStart) }
    }

    var resolvedFirstWeekday: Int {
        weekStart.firstWeekday
    }

    private(set) var customCategories: [AppCategory] = [] {
        didSet { persistCustomCategories() }
    }

    private(set) var customUnits: [String] = [] {
        didSet { persistCustomUnits() }
    }

    var allCategories: [AppCategory] {
        Self.defaultCategories + customCategories
    }

    var allUnits: [String] {
        let extras = customUnits.filter { unit in
            !Self.defaultUnits.contains { $0.caseInsensitiveCompare(unit) == .orderedSame }
        }
        return Self.defaultUnits + extras
    }

    private init() {
        if let rawTheme = UserDefaults.standard.string(forKey: Keys.appTheme),
           let theme = AppTheme(rawValue: rawTheme) {
            appTheme = theme
        } else {
            appTheme = .system
        }

        let storedServings = UserDefaults.standard.integer(forKey: Keys.defaultPlannerServings)
        defaultPlannerServings = storedServings > 0 ? storedServings : 1
        includeBreakfastInMealPrep = UserDefaults.standard.bool(forKey: Keys.includeBreakfastInMealPrep)
        if let rawSound = UserDefaults.standard.string(forKey: Keys.timerAlarmSound),
           let sound = TimerAlarmSound(rawValue: rawSound) {
            timerAlarmSound = sound
        } else {
            timerAlarmSound = .defaultSound
        }
        // Migrate away from the removed "system" week-start option.
        if let rawWeekStart = UserDefaults.standard.string(forKey: Keys.weekStart),
           rawWeekStart != "system",
           let storedWeekStart = WeekStartSetting(rawValue: rawWeekStart) {
            weekStart = storedWeekStart
        } else {
            weekStart = .monday
        }
        TimerAlarmSoundInstaller.ensureInstalled(timerAlarmSound)
        customCategories = Self.sanitizeCustomCategories(Self.loadCustomCategories())
        customUnits = Self.sanitizeCustomUnits(Self.loadCustomUnits())
    }

    func resetToDefaults() {
        appTheme = .system
        defaultPlannerServings = 1
        includeBreakfastInMealPrep = false
        timerAlarmSound = .defaultSound
        weekStart = .monday
        customCategories = []
        customUnits = []
    }

    func label(forCategoryID id: String) -> String {
        allCategories.first { $0.id == id }?.label
            ?? id.replacingOccurrences(of: "-", with: " ").capitalized
    }

    func labels(forTagIDs tags: [String]) -> [String] {
        tags.map { label(forCategoryID: $0) }
    }

    func isDefaultCategory(id: String) -> Bool {
        Self.defaultCategories.contains { $0.id == id }
    }

    func isDefaultUnit(_ unit: String) -> Bool {
        Self.defaultUnits.contains { $0.caseInsensitiveCompare(unit) == .orderedSame }
    }

    @discardableResult
    func addCategory(label: String) -> Bool {
        let trimmed = label.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        let id = Self.slugify(trimmed)
        guard !allCategories.contains(where: { $0.id == id }) else { return false }

        customCategories.append(AppCategory(id: id, label: trimmed, isDefault: false))
        customCategories.sort { $0.label.localizedCaseInsensitiveCompare($1.label) == .orderedAscending }
        return true
    }

    func removeCategory(id: String) {
        guard !isDefaultCategory(id: id) else { return }
        customCategories.removeAll { $0.id == id }
    }

    @discardableResult
    func addUnit(_ unit: String) -> Bool {
        let trimmed = unit.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard !allUnits.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) else { return false }

        customUnits.append(trimmed)
        customUnits.sort { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        return true
    }

    func removeUnit(_ unit: String) {
        guard !isDefaultUnit(unit) else { return }
        customUnits.removeAll { $0.caseInsensitiveCompare(unit) == .orderedSame }
    }

    private static func slugify(_ text: String) -> String {
        text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "_", with: "-")
            .replacingOccurrences(of: " ", with: "-")
    }

    private static func loadCustomCategories() -> [AppCategory] {
        guard let data = UserDefaults.standard.data(forKey: Keys.customCategories),
              let decoded = try? JSONDecoder().decode([AppCategory].self, from: data) else {
            return []
        }
        return decoded
    }

    private static func sanitizeCustomCategories(_ categories: [AppCategory]) -> [AppCategory] {
        let defaultIDs = Set(defaultCategories.map(\.id))
        return categories.filter { category in
            !category.isDefault && !defaultIDs.contains(category.id)
        }
    }

    private static func loadCustomUnits() -> [String] {
        UserDefaults.standard.stringArray(forKey: Keys.customUnits) ?? []
    }

    private static func sanitizeCustomUnits(_ units: [String]) -> [String] {
        units.filter { unit in
            !defaultUnits.contains { $0.caseInsensitiveCompare(unit) == .orderedSame }
        }
    }

    private func persistCustomCategories() {
        if let data = try? JSONEncoder().encode(customCategories) {
            UserDefaults.standard.set(data, forKey: Keys.customCategories)
        }
    }

    private func persistCustomUnits() {
        UserDefaults.standard.set(customUnits, forKey: Keys.customUnits)
    }
}

enum AppMetadata {
    static let advancedProFeaturesStatus = "Coming soon"
    static let advancedSectionFooter =
        "CookGPT Advanced unlocks pro features with a subscription or one-time purchase."

    static var version: String {
        let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
        return "\(short) (\(build))"
    }

    static var languageName: String {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code.uppercased()
    }
}
