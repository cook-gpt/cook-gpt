//  AppSettingsStore.swift
//  CookGPT
//
//  UserDefaults-backed app preferences (theme, planner, timers, categories, units).
//

import Foundation

struct AppCategory: Identifiable, Codable, Hashable {
    let id: String
    let label: String
}

/// Central store for user preferences persisted in `UserDefaults`.
@Observable
@MainActor
final class AppSettingsStore {
    static let shared = AppSettingsStore()

    static let mealPlannerExcludedCategoryIDs: Set<String> = ["breakfast", "dessert"]

    static let defaultCategories: [AppCategory] = [
        AppCategory(id: "vegan", label: "Vegan"),
        AppCategory(id: "vegetarian", label: "Vegetarian"),
        AppCategory(id: "high-protein", label: "High protein"),
        AppCategory(id: "low-carbs", label: "Low carbs"),
        AppCategory(id: "no-carbs", label: "No carbs"),
        AppCategory(id: "no-fats", label: "No fats"),
        AppCategory(id: "quick", label: "Quick"),
        AppCategory(id: "italian", label: "Italian"),
        AppCategory(id: "meal-prep", label: "Meal prep"),
        AppCategory(id: "breakfast", label: "Breakfast"),
        AppCategory(id: "dessert", label: "Dessert"),
    ]

    private enum Keys {
        static let appTheme = "appSettings.appTheme"
        static let defaultPlannerServings = "appSettings.defaultPlannerServings"
        static let timerAlarmSound = "appSettings.timerAlarmSound"
        static let weekStart = "appSettings.weekStart"
        static let categories = "appSettings.categories"
        static let customCategories = "appSettings.customCategories"
        static let measurementSystem = "appSettings.measurementSystem"
        static let recipeFilterActiveCategoryIDs = "appSettings.recipeFilterActiveCategoryIDs"
    }

    var appTheme: AppTheme = .system {
        didSet { UserDefaults.standard.set(appTheme.rawValue, forKey: Keys.appTheme) }
    }

    var defaultPlannerServings: Int {
        didSet { UserDefaults.standard.set(defaultPlannerServings, forKey: Keys.defaultPlannerServings) }
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

    var measurementSystem: MeasurementSystem = .metric {
        didSet { UserDefaults.standard.set(measurementSystem.rawValue, forKey: Keys.measurementSystem) }
    }

    var resolvedFirstWeekday: Int {
        weekStart.firstWeekday
    }

    private(set) var categories: [AppCategory] = [] {
        didSet { persistCategories() }
    }

    /// Ordered active category IDs for the Recipes filter bar. Empty means all categories are active.
    private(set) var recipeFilterActiveCategoryIDs: [String] = [] {
        didSet { persistRecipeFilterActiveCategoryIDs() }
    }

    /// Ingredient and grocery unit options for the selected measurement system.
    var availableUnits: [String] {
        measurementSystem.units
    }

    /// Default unit when adding new ingredients or grocery items.
    var defaultIngredientUnit: String {
        measurementSystem.defaultUnit
    }

    /// When true, data tabs avoid reading SwiftData models (used during factory reset).
    private(set) var isResettingData = false

    /// Bumped to remount root UI after a factory reset so `@Query` views drop stale models.
    private(set) var contentResetID = UUID()

    var allCategories: [AppCategory] {
        categories
    }

    /// Categories shown in the Recipes filter bar, in display order.
    var visibleRecipeFilterCategories: [AppCategory] {
        categories(for: effectiveRecipeFilterActiveCategoryIDs())
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
        if let rawSystem = UserDefaults.standard.string(forKey: Keys.measurementSystem),
           let storedSystem = MeasurementSystem(rawValue: rawSystem) {
            measurementSystem = storedSystem
        } else {
            measurementSystem = MeasurementSystem.preferredForCurrentLocale
        }
        TimerAlarmSoundInstaller.ensureInstalled(timerAlarmSound)
        categories = Self.loadCategories()
        recipeFilterActiveCategoryIDs = Self.loadRecipeFilterActiveCategoryIDs()
    }

    func resetToDefaults() {
        appTheme = .system
        defaultPlannerServings = 1
        timerAlarmSound = .defaultSound
        weekStart = .monday
        measurementSystem = MeasurementSystem.preferredForCurrentLocale
        categories = Self.defaultCategories
        recipeFilterActiveCategoryIDs = []
    }

    func effectiveRecipeFilterActiveCategoryIDs() -> [String] {
        let allIDs = allCategories.map(\.id)
        guard !allIDs.isEmpty else { return [] }

        if recipeFilterActiveCategoryIDs.isEmpty {
            return allIDs
        }

        var activeIDs = recipeFilterActiveCategoryIDs.filter { allIDs.contains($0) }
        return activeIDs
    }

    func inactiveRecipeFilterCategoryIDs() -> [String] {
        let active = Set(effectiveRecipeFilterActiveCategoryIDs())
        return allCategories.map(\.id).filter { !active.contains($0) }
    }

    func setRecipeFilterActiveCategoryIDs(_ ids: [String]) {
        let allIDs = Set(allCategories.map(\.id))
        recipeFilterActiveCategoryIDs = ids.filter { allIDs.contains($0) }
    }

    func setRecipeFilterCategory(_ id: String, isActive: Bool) {
        var ids = effectiveRecipeFilterActiveCategoryIDs()
        if isActive {
            guard !ids.contains(id) else { return }
            ids.append(id)
        } else {
            ids.removeAll { $0 == id }
        }
        setRecipeFilterActiveCategoryIDs(ids)
    }

    func beginDataReset() {
        isResettingData = true
        contentResetID = UUID()
    }

    func endDataReset() {
        isResettingData = false
        contentResetID = UUID()
    }

    func label(forCategoryID id: String) -> String {
        allCategories.first { $0.id == id }?.label
            ?? id.replacingOccurrences(of: "-", with: " ").capitalized
    }

    func labels(forTagIDs tags: [String]) -> [String] {
        tags.map { label(forCategoryID: $0) }
    }

    @discardableResult
    func addCategory(label: String) -> Bool {
        let trimmed = label.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        let id = Self.slugify(trimmed)
        guard !categories.contains(where: { $0.id == id }) else { return false }

        categories.append(AppCategory(id: id, label: trimmed))
        if recipeFilterActiveCategoryIDs.isEmpty {
            return true
        }
        var activeIDs = effectiveRecipeFilterActiveCategoryIDs()
        if !activeIDs.contains(id) {
            activeIDs.append(id)
            setRecipeFilterActiveCategoryIDs(activeIDs)
        }
        return true
    }

    func removeCategory(id: String) {
        categories.removeAll { $0.id == id }
        if !recipeFilterActiveCategoryIDs.isEmpty {
            setRecipeFilterActiveCategoryIDs(
                recipeFilterActiveCategoryIDs.filter { $0 != id }
            )
        }
    }

    private static func slugify(_ text: String) -> String {
        text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "_", with: "-")
            .replacingOccurrences(of: " ", with: "-")
    }

    private static func loadCategories() -> [AppCategory] {
        if let data = UserDefaults.standard.data(forKey: Keys.categories),
           let decoded = try? JSONDecoder().decode([AppCategory].self, from: data),
           !decoded.isEmpty {
            return decoded
        }

        let legacyCustom = loadLegacyCustomCategories()
        if legacyCustom.isEmpty, UserDefaults.standard.data(forKey: Keys.customCategories) == nil {
            return defaultCategories
        }

        var merged = defaultCategories
        let existingIDs = Set(merged.map(\.id))
        for category in legacyCustom where !existingIDs.contains(category.id) {
            merged.append(AppCategory(id: category.id, label: category.label))
        }
        return merged
    }

    private static func loadLegacyCustomCategories() -> [AppCategory] {
        guard let data = UserDefaults.standard.data(forKey: Keys.customCategories),
              let decoded = try? JSONDecoder().decode([AppCategory].self, from: data) else {
            return []
        }
        return decoded
    }

    private func persistCategories() {
        if let data = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(data, forKey: Keys.categories)
        }
    }

    private func persistRecipeFilterActiveCategoryIDs() {
        UserDefaults.standard.set(recipeFilterActiveCategoryIDs, forKey: Keys.recipeFilterActiveCategoryIDs)
    }

    private func categories(for ids: [String]) -> [AppCategory] {
        let lookup = Dictionary(uniqueKeysWithValues: allCategories.map { ($0.id, $0) })
        return ids.compactMap { lookup[$0] }
    }

    private static func loadRecipeFilterActiveCategoryIDs() -> [String] {
        UserDefaults.standard.stringArray(forKey: Keys.recipeFilterActiveCategoryIDs) ?? []
    }
}

enum AppMetadata {
    static let privacyPolicyURL = URL(string: "https://cook-gpt.pages.dev/privacy")!
    static let sourceCodeURL = URL(string: "https://github.com/cook-gpt/cook-gpt")!

    static let advancedProFeaturesStatus = "Coming soon"
    static let advancedSectionFooter =
        "Additional pro features are planned for a future update. The current version is free and includes no in-app purchases or subscriptions."

    static let shareAttribution = "Made with CookGPT: Gourmet Plan & Taste"

    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    static var languageName: String {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code.uppercased()
    }
}
