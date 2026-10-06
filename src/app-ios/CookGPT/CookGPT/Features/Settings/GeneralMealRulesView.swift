//  GeneralMealRulesView.swift
//  CookGPT
//
//  Global meal-planning category rules for all diets.
//

import SwiftUI

struct GeneralMealRulesView: View {
    @Environment(AppSettingsStore.self) private var settings

    @State private var allMealsForbidden = Set<String>()
    @State private var breakfastMandatory = Set<String>()
    @State private var breakfastForbidden = Set<String>()
    @State private var lunchMandatory = Set<String>()
    @State private var lunchForbidden = Set<String>()
    @State private var dinnerMandatory = Set<String>()
    @State private var dinnerForbidden = Set<String>()
    @State private var hasLoadedRules = false

    var body: some View {
        Form {
            Section {
                NavigationLink {
                    CategoryIDSetEditor(
                        selectedCategoryIDs: $allMealsForbidden,
                        navigationTitle: String(localized: "Forbidden for all meals")
                    )
                } label: {
                    LabeledContent(
                        String(localized: "Forbidden for all meals"),
                        value: settings.selectionLabel(forCategoryIDs: allMealsForbidden)
                    )
                }
            } footer: {
                Text("These categories are never used when planning breakfast, lunch, or dinner.")
            }

            mealSlotSection(
                title: String(localized: "Breakfast"),
                mandatory: $breakfastMandatory,
                forbidden: $breakfastForbidden,
                footer: String(localized: "Breakfast planning only uses recipes that match these rules plus each diet’s rules.")
            )

            mealSlotSection(
                title: String(localized: "Lunch"),
                mandatory: $lunchMandatory,
                forbidden: $lunchForbidden,
                footer: String(localized: "Lunch planning uses these rules in addition to the global and diet rules.")
            )

            mealSlotSection(
                title: String(localized: "Dinner"),
                mandatory: $dinnerMandatory,
                forbidden: $dinnerForbidden,
                footer: String(localized: "Dinner planning uses these rules in addition to the global and diet rules.")
            )
        }
        .navigationTitle("General meal rules")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !hasLoadedRules else { return }
            hasLoadedRules = true
            loadFromSettings()
        }
        .onChange(of: allMealsForbidden) { _, _ in saveToSettings() }
        .onChange(of: breakfastMandatory) { _, _ in saveToSettings() }
        .onChange(of: breakfastForbidden) { _, _ in saveToSettings() }
        .onChange(of: lunchMandatory) { _, _ in saveToSettings() }
        .onChange(of: lunchForbidden) { _, _ in saveToSettings() }
        .onChange(of: dinnerMandatory) { _, _ in saveToSettings() }
        .onChange(of: dinnerForbidden) { _, _ in saveToSettings() }
    }

    @ViewBuilder
    private func mealSlotSection(
        title: String,
        mandatory: Binding<Set<String>>,
        forbidden: Binding<Set<String>>,
        footer: String
    ) -> some View {
        Section {
            CategoryRulesEditorSection(
                mandatoryCategoryIDs: mandatory,
                forbiddenCategoryIDs: forbidden
            )
        } header: {
            Text(title)
        } footer: {
            Text(footer)
        }
    }

    private func loadFromSettings() {
        let rules = settings.globalMealPlanningRules
        allMealsForbidden = Set(rules.allMealsForbiddenCategoryIDs)
        breakfastMandatory = Set(rules.breakfast.mandatoryCategoryIDs)
        breakfastForbidden = Set(rules.breakfast.forbiddenCategoryIDs)
        lunchMandatory = Set(rules.lunch.mandatoryCategoryIDs)
        lunchForbidden = Set(rules.lunch.forbiddenCategoryIDs)
        dinnerMandatory = Set(rules.dinner.mandatoryCategoryIDs)
        dinnerForbidden = Set(rules.dinner.forbiddenCategoryIDs)
    }

    private func saveToSettings() {
        settings.globalMealPlanningRules = GlobalMealPlanningRules(
            allMealsForbiddenCategoryIDs: Array(allMealsForbidden).sorted(),
            breakfast: DietCategoryRules(
                mandatoryCategoryIDs: Array(breakfastMandatory).sorted(),
                forbiddenCategoryIDs: Array(breakfastForbidden).sorted()
            ),
            lunch: DietCategoryRules(
                mandatoryCategoryIDs: Array(lunchMandatory).sorted(),
                forbiddenCategoryIDs: Array(lunchForbidden).sorted()
            ),
            dinner: DietCategoryRules(
                mandatoryCategoryIDs: Array(dinnerMandatory).sorted(),
                forbiddenCategoryIDs: Array(dinnerForbidden).sorted()
            )
        )
    }

}
