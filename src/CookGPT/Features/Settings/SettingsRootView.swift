//  SettingsRootView.swift
//  CookGPT
//
//  Settings tab: appearance, planner, categories, units, about, reset.
//

import SwiftUI
import SwiftData

struct SettingsRootView: View {
    @Environment(AppSettingsStore.self) private var settings
    @Environment(\.modelContext) private var modelContext
    @Environment(CookingSessionManager.self) private var cookingSession

    @State private var isAddingCategory = false
    @State private var newCategoryLabel = ""
    @State private var showResetConfirmation = false
    @State private var isResetting = false

    var body: some View {
        @Bindable var settings = settings

        List {
            SettingsSegmentedSection(settings: settings, unitsDetail: defaultUnitsDetail)
            SettingsToggleSection(settings: settings)
            SettingsStepperSection(settings: settings)
            SettingsMenuPickerSection(settings: settings)
            SettingsNavigationSection(settings: settings)
            SettingsCategoriesSection(
                settings: settings,
                categoriesDetail: defaultCategoriesDetail,
                onAdd: {
                    newCategoryLabel = ""
                    isAddingCategory = true
                },
                onDelete: deleteCustomCategories
            )
            SettingsInformationSection()
            SettingsResetSection(
                isResetting: isResetting,
                showResetConfirmation: $showResetConfirmation
            )
        }
        .navigationTitle("Settings")
        .alert("Add category", isPresented: $isAddingCategory) {
            TextField("Category name", text: $newCategoryLabel)
            Button("Cancel", role: .cancel) {}
            Button("Add") {
                _ = settings.addCategory(label: newCategoryLabel)
            }
        }
        .alert("Reset app data?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                Task { await performReset() }
            }
        } message: {
            Text("This will permanently delete all recipes, scheduled meals, groceries, timers, and custom settings, then restore default data. This cannot be undone.")
        }
    }

    private var defaultCategoriesDetail: String {
        let labels = AppSettingsStore.defaultCategories.map(\.label)
        return "Built-in: " + labels.joined(separator: ", ")
    }

    private var defaultUnitsDetail: String {
        let metric = MeasurementSystem.metric.units.joined(separator: ", ")
        let imperial = MeasurementSystem.imperial.units.joined(separator: ", ")
        return "Metric: \(metric)\nImperial: \(imperial)"
    }

    private func performReset() async {
        isResetting = true
        await AppDataReset.resetToDefaults(
            context: modelContext,
            settings: settings,
            cookingSession: cookingSession
        )
        isResetting = false
    }

    private func deleteCustomCategories(at offsets: IndexSet) {
        let categories = settings.customCategories
        for index in offsets {
            guard categories.indices.contains(index) else { continue }
            settings.removeCategory(id: categories[index].id)
        }
    }
}

// MARK: - Segmented controls

private struct SettingsSegmentedSection: View {
    @Bindable var settings: AppSettingsStore
    let unitsDetail: String

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Theme")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("Theme", selection: $settings.appTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.label).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Units")
                    SettingsInfoButton(
                        detail: unitsDetail,
                        accessibilityLabel: "Units information"
                    )
                    Spacer(minLength: 0)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Picker("Units", selection: $settings.measurementSystem) {
                    ForEach(MeasurementSystem.allCases) { system in
                        Text(system.label).tag(system)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
        } footer: {
            Text("Metric or imperial units for ingredients and grocery items.")
        }
    }
}

// MARK: - Toggle

private struct SettingsToggleSection: View {
    @Bindable var settings: AppSettingsStore

    var body: some View {
        Section {
            Toggle("Include breakfast", isOn: $settings.includeBreakfastInMealPrep)
        } footer: {
            Text("When enabled, auto meal planning also schedules breakfast. Breakfast and dessert recipes are never used by the planner.")
        }
    }
}

// MARK: - Stepper

private struct SettingsStepperSection: View {
    @Bindable var settings: AppSettingsStore

    var body: some View {
        Section {
            Stepper(
                "Default servings: \(settings.defaultPlannerServings)",
                value: $settings.defaultPlannerServings,
                in: 1...12
            )
        } footer: {
            Text("Used when planning meals and as the default for new scheduled meals.")
        }
    }
}

// MARK: - Menu picker

private struct SettingsMenuPickerSection: View {
    @Bindable var settings: AppSettingsStore

    var body: some View {
        Section {
            Picker("Week starts on", selection: $settings.weekStart) {
                ForEach(WeekStartSetting.allCases) { option in
                    Text(option.label).tag(option)
                }
            }
        } footer: {
            Text("Used when navigating weeks on the Meals page.")
        }
    }
}

// MARK: - Navigation

private struct SettingsNavigationSection: View {
    @Bindable var settings: AppSettingsStore

    var body: some View {
        Section {
            NavigationLink {
                TimerAlarmSoundPickerView()
            } label: {
                LabeledContent("Alarm sound", value: settings.timerAlarmSound.label)
            }
        } footer: {
            Text("Uses the same alarm names as the iPhone Clock app. Previews and timer audio require a physical device.")
        }
    }
}

// MARK: - Editable list

private struct SettingsCategoriesSection: View {
    @Bindable var settings: AppSettingsStore
    let categoriesDetail: String
    let onAdd: () -> Void
    let onDelete: (IndexSet) -> Void

    var body: some View {
        Section {
            if settings.customCategories.isEmpty {
                Text("No custom categories yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(settings.customCategories) { category in
                    Text(category.label)
                }
                .onDelete(perform: onDelete)
            }

            Button(action: onAdd) {
                Label("Add category", systemImage: "plus")
            }
        } header: {
            SettingsSectionInfoHeader(
                title: "Categories",
                detail: categoriesDetail
            )
        } footer: {
            Text("Built-in categories cannot be removed. Tap or hover the info icon to see them.")
        }
    }
}

// MARK: - Information

private struct SettingsInformationSection: View {
    var body: some View {
        Section {
            LabeledContent("Pro features", value: AppMetadata.advancedProFeaturesStatus)
            LabeledContent("Version", value: AppMetadata.version)
            LabeledContent("Language", value: AppMetadata.languageName)
            Link("Privacy Policy", destination: AppMetadata.privacyPolicyURL)
            Link("Source Code", destination: AppMetadata.sourceCodeURL)
        } footer: {
            VStack(alignment: .leading, spacing: 8) {
                Text(AppMetadata.advancedSectionFooter)
                Text("Language follows your device settings.")
            }
        }
    }
}

// MARK: - Destructive action

private struct SettingsResetSection: View {
    let isResetting: Bool
    @Binding var showResetConfirmation: Bool

    var body: some View {
        Section {
            Button(role: .destructive) {
                showResetConfirmation = true
            } label: {
                HStack {
                    Spacer()
                    if isResetting {
                        ProgressView()
                    } else {
                        Text("Reset app data")
                    }
                    Spacer()
                }
            }
            .disabled(isResetting)
        } footer: {
            Text("Deletes all recipes, meals, groceries, timers, and custom settings, then restores the default install data.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsRootView()
    }
    .environment(AppSettingsStore.shared)
    .environment(CookingSessionManager.shared)
    .modelContainer(try! CookGPTModelContainer.make())
}
