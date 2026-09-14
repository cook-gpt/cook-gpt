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
            SettingsAppearanceSection(settings: settings)
            SettingsAlarmSoundSection(settings: settings)
            SettingsAdvancedSection()
            SettingsInformationSection()
            SettingsLinksSection()
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

// MARK: - Appearance

private struct SettingsAppearanceSection: View {
    @Bindable var settings: AppSettingsStore

    private var unitsDifferenceFooter: String {
        let imperialUnits = Set(MeasurementSystem.imperial.units)
        let metricOnly = MeasurementSystem.metric.units.filter { !imperialUnits.contains($0) }
        let metricUnits = Set(MeasurementSystem.metric.units)
        let imperialOnly = MeasurementSystem.imperial.units.filter { !metricUnits.contains($0) }

        let metricLabels = metricOnly
            .map { IngredientUnitFormatting.localizedLabel(for: $0) }
            .joined(separator: ", ")
        let imperialLabels = imperialOnly
            .map { IngredientUnitFormatting.localizedLabel(for: $0) }
            .joined(separator: ", ")

        return String(
            format: String(localized: "Metric uses %@. Imperial uses %@."),
            metricLabels,
            imperialLabels
        )
    }

    var body: some View {
        Section {
            Picker("Theme", selection: $settings.appTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.label).tag(theme)
                }
            }
            .pickerStyle(.segmented)

            Picker("Units", selection: $settings.measurementSystem) {
                ForEach(MeasurementSystem.allCases) { system in
                    Text(system.label).tag(system)
                }
            }
            .pickerStyle(.segmented)
        } footer: {
            Text(unitsDifferenceFooter)
        }
    }
}

private struct SettingsAlarmSoundSection: View {
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
