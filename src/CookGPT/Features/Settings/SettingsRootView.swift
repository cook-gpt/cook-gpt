//  SettingsRootView.swift
//  CookGPT
//
//  Settings tab: appearance, planner, units, about, reset.
//

import SwiftUI
import SwiftData

struct SettingsRootView: View {
    @Environment(AppSettingsStore.self) private var settings
    @Environment(\.modelContext) private var modelContext
    @Environment(CookingSessionManager.self) private var cookingSession

    @State private var showResetConfirmation = false
    @State private var isResetting = false

    var body: some View {
        @Bindable var settings = settings

        List {
            SettingsSegmentedSection(settings: settings, unitsDetail: defaultUnitsDetail)
            SettingsStepperSection(settings: settings)
            SettingsMenuPickerSection(settings: settings)
            SettingsNavigationSection(settings: settings)
            SettingsAdvancedSection()
            SettingsInformationSection()
            SettingsLinksSection()
            SettingsTutorialSection()
            SettingsResetSection(
                isResetting: isResetting,
                showResetConfirmation: $showResetConfirmation
            )
        }
        .navigationTitle("Settings")
        .alert("Reset app data?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                Task { await performReset() }
            }
        } message: {
            Text("This will permanently delete all recipes, scheduled meals, groceries, timers, and custom settings, then restore default data. This cannot be undone.")
        }
    }

    private var defaultUnitsDetail: String {
        let metric = MeasurementSystem.metric.units
            .map { IngredientUnitFormatting.localizedLabel(for: $0) }
            .joined(separator: ", ")
        let imperial = MeasurementSystem.imperial.units
            .map { IngredientUnitFormatting.localizedLabel(for: $0) }
            .joined(separator: ", ")
        return String(format: String(localized: "Metric: %@\nImperial: %@"), metric, imperial)
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

// MARK: - Stepper

private struct SettingsStepperSection: View {
    @Bindable var settings: AppSettingsStore

    var body: some View {
        Section {
            Stepper(
                String(
                    format: String(localized: "Default servings: %lld"),
                    settings.defaultPlannerServings
                ),
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

// MARK: - Advanced

private struct SettingsAdvancedSection: View {
    var body: some View {
        Section {
            NavigationLink {
                DietSettingsRootView()
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Diets")
                    Text("Custom meal-planning rules and general breakfast, lunch, and dinner rules")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("Advanced")
        } footer: {
            Text("Create diets such as keto or low-carb plans using mandatory and forbidden recipe categories.")
        }
    }
}

// MARK: - Information

private struct SettingsInformationSection: View {
    var body: some View {
        Section {
            LabeledContent("Version", value: AppMetadata.version)
            LabeledContent("Language", value: AppMetadata.languageName)
        } footer: {
            Text("Change language in Settings → CookGPT → Language.")
        }
    }
}

private struct SettingsLinksSection: View {
    var body: some View {
        Section {
            Link("Privacy Policy", destination: AppMetadata.privacyPolicyURL)
            Link("Source Code", destination: AppMetadata.sourceCodeURL)
        }
    }
}

// MARK: - Tutorial

private struct SettingsTutorialSection: View {
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        Section {
            Button("Reset tutorial") {
                settings.resetOnboardingTutorial()
            }
        } footer: {
            Text("Shows the first-launch walkthrough again without changing your recipes or categories.")
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
            Text("Deletes all recipes, meals, groceries, timers, and custom settings, then shows the first-launch walkthrough again.")
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
