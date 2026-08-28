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
            Section("Appearance") {
                Picker("Theme", selection: $settings.appTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.label).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Timers") {
                NavigationLink {
                    TimerAlarmSoundPickerView()
                } label: {
                    LabeledContent("Alarm sound", value: settings.timerAlarmSound.label)
                }
                Text("Uses the same alarm names as the iPhone Clock app. Previews and timer audio require a physical device.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Meal planner") {
                Toggle("Include breakfast", isOn: $settings.includeBreakfastInMealPrep)
                Text("When enabled, auto meal planning also schedules breakfast. Breakfast and dessert recipes are never used by the planner.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Stepper(
                    "Default servings: \(settings.defaultPlannerServings)",
                    value: $settings.defaultPlannerServings,
                    in: 1...12
                )
                Text("Used when planning meals and as the default for new scheduled meals.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Picker("Week starts on", selection: $settings.weekStart) {
                    ForEach(WeekStartSetting.allCases) { option in
                        Text(option.label).tag(option)
                    }
                }
                Text("Used when navigating weeks on the Meals page.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section {
                ForEach(AppSettingsStore.defaultCategories) { category in
                    HStack {
                        Text(category.label)
                        Spacer()
                        Text("Default")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Default categories")
            }

            Section {
                if settings.customCategories.isEmpty {
                    Text("No custom categories yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(settings.customCategories) { category in
                        Text(category.label)
                    }
                    .onDelete(perform: deleteCustomCategories)
                }

                Button {
                    newCategoryLabel = ""
                    isAddingCategory = true
                } label: {
                    Label("Add category", systemImage: "plus")
                }
            } header: {
                Text("Custom categories")
            } footer: {
                Text("Default categories cannot be removed. Custom categories appear in recipes and filters.")
            }

            Section {
                Picker("Measurement system", selection: $settings.measurementSystem) {
                    ForEach(MeasurementSystem.allCases) { system in
                        Text(system.label).tag(system)
                    }
                }
                .pickerStyle(.segmented)

                ForEach(settings.availableUnits, id: \.self) { unit in
                    Text(unit)
                }
            } header: {
                Text("Units")
            } footer: {
                Text("Choose metric or US customary units for ingredients and grocery items.")
            }

            Section {
                LabeledContent("Pro features", value: AppMetadata.advancedProFeaturesStatus)
            } header: {
                Text("Advanced")
            } footer: {
                Text(AppMetadata.advancedSectionFooter)
            }

            Section("About") {
                LabeledContent("Version", value: AppMetadata.version)
                LabeledContent("Language", value: AppMetadata.languageName)
                Text("Language follows your device settings.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Link("Privacy Policy", destination: AppMetadata.privacyPolicyURL)
                Link("Source Code", destination: AppMetadata.sourceCodeURL)
            }

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

#Preview {
    NavigationStack {
        SettingsRootView()
    }
    .environment(AppSettingsStore.shared)
    .environment(CookingSessionManager.shared)
    .modelContainer(try! CookGPTModelContainer.make())
}
