//  DietEditorView.swift
//  CookGPT
//
//  Create or edit a custom diet profile and its category rules.
//

import SwiftUI
import SwiftData

struct DietEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @Bindable var profile: DietProfile
    let isNew: Bool

    @State private var mandatoryCategoryIDs = Set<String>()
    @State private var forbiddenCategoryIDs = Set<String>()
    @State private var usesBreakfastSlotRules = false
    @State private var usesLunchSlotRules = false
    @State private var usesDinnerSlotRules = false
    @State private var breakfastMandatory = Set<String>()
    @State private var breakfastForbidden = Set<String>()
    @State private var lunchMandatory = Set<String>()
    @State private var lunchForbidden = Set<String>()
    @State private var dinnerMandatory = Set<String>()
    @State private var dinnerForbidden = Set<String>()
    @State private var hasLoadedProfile = false

    var body: some View {
        Form {
            Section {
                TextField(String(localized: "Name"), text: $profile.name)

                Toggle(String(localized: "Default diet"), isOn: $profile.isActive)
            }

            Section {
                CategoryRulesEditorSection(
                    mandatoryCategoryIDs: $mandatoryCategoryIDs,
                    forbiddenCategoryIDs: $forbiddenCategoryIDs
                )
            } header: {
                Text("General diet rules")
            } footer: {
                Text("Recipes must match at least one mandatory category in each group and cannot include any forbidden category. These rules apply to every meal unless a meal-specific override is enabled below.")
            }

            slotOverrideSection(
                title: String(localized: "Breakfast"),
                isEnabled: $usesBreakfastSlotRules,
                mandatory: $breakfastMandatory,
                forbidden: $breakfastForbidden
            )

            slotOverrideSection(
                title: String(localized: "Lunch"),
                isEnabled: $usesLunchSlotRules,
                mandatory: $lunchMandatory,
                forbidden: $lunchForbidden
            )

            slotOverrideSection(
                title: String(localized: "Dinner"),
                isEnabled: $usesDinnerSlotRules,
                mandatory: $dinnerMandatory,
                forbidden: $dinnerForbidden
            )
        }
        .navigationTitle(isNew ? String(localized: "New diet") : String(localized: "Edit diet"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                }
                .disabled(profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel("Save")
            }
        }
        .onAppear {
            guard !hasLoadedProfile else { return }
            hasLoadedProfile = true
            loadFromProfile()
        }
    }

    @ViewBuilder
    private func slotOverrideSection(
        title: String,
        isEnabled: Binding<Bool>,
        mandatory: Binding<Set<String>>,
        forbidden: Binding<Set<String>>
    ) -> some View {
        Section {
            Toggle(String(localized: "Custom rules for this meal"), isOn: isEnabled)

            if isEnabled.wrappedValue {
                CategoryRulesEditorSection(
                    mandatoryCategoryIDs: mandatory,
                    forbiddenCategoryIDs: forbidden
                )
            }
        } header: {
            Text(title)
        }
    }

    private func loadFromProfile() {
        mandatoryCategoryIDs = Set(profile.mandatoryCategoryIDs)
        forbiddenCategoryIDs = Set(profile.forbiddenCategoryIDs)
        usesBreakfastSlotRules = profile.usesBreakfastSlotRules
        usesLunchSlotRules = profile.usesLunchSlotRules
        usesDinnerSlotRules = profile.usesDinnerSlotRules
        breakfastMandatory = Set(profile.breakfastMandatoryCategoryIDs)
        breakfastForbidden = Set(profile.breakfastForbiddenCategoryIDs)
        lunchMandatory = Set(profile.lunchMandatoryCategoryIDs)
        lunchForbidden = Set(profile.lunchForbiddenCategoryIDs)
        dinnerMandatory = Set(profile.dinnerMandatoryCategoryIDs)
        dinnerForbidden = Set(profile.dinnerForbiddenCategoryIDs)
        normalizeEmptySlotOverrides()
    }

    private func normalizeEmptySlotOverrides() {
        if usesBreakfastSlotRules,
           breakfastMandatory.isEmpty,
           breakfastForbidden.isEmpty {
            usesBreakfastSlotRules = false
            breakfastMandatory = []
            breakfastForbidden = []
        }

        if usesLunchSlotRules,
           lunchMandatory.isEmpty,
           lunchForbidden.isEmpty {
            usesLunchSlotRules = false
            lunchMandatory = []
            lunchForbidden = []
        }

        if usesDinnerSlotRules,
           dinnerMandatory.isEmpty,
           dinnerForbidden.isEmpty {
            usesDinnerSlotRules = false
            dinnerMandatory = []
            dinnerForbidden = []
        }
    }

    private func applyToProfile() {
        profile.mandatoryCategoryIDs = Array(mandatoryCategoryIDs).sorted()
        profile.forbiddenCategoryIDs = Array(forbiddenCategoryIDs).sorted()
        profile.usesBreakfastSlotRules = usesBreakfastSlotRules
        profile.usesLunchSlotRules = usesLunchSlotRules
        profile.usesDinnerSlotRules = usesDinnerSlotRules
        profile.breakfastMandatoryCategoryIDs = Array(breakfastMandatory).sorted()
        profile.breakfastForbiddenCategoryIDs = Array(breakfastForbidden).sorted()
        profile.lunchMandatoryCategoryIDs = Array(lunchMandatory).sorted()
        profile.lunchForbiddenCategoryIDs = Array(lunchForbidden).sorted()
        profile.dinnerMandatoryCategoryIDs = Array(dinnerMandatory).sorted()
        profile.dinnerForbiddenCategoryIDs = Array(dinnerForbidden).sorted()
    }

    private func save() {
        normalizeEmptySlotOverrides()
        applyToProfile()

        if profile.isActive {
            let descriptor = FetchDescriptor<DietProfile>()
            let profiles = (try? modelContext.fetch(descriptor)) ?? []
            for other in profiles where other.id != profile.id {
                other.isActive = false
            }
        }

        if isNew {
            modelContext.insert(profile)
        }

        try? modelContext.save()
        dismiss()
    }
}
