//  CategoryRulesEditorViews.swift
//  CookGPT
//
//  Reusable editors for mandatory and forbidden recipe categories.
//

import SwiftUI

struct CategoryIDSetEditor: View {
    @Binding var selectedCategoryIDs: Set<String>
    @Environment(\.dismiss) private var dismiss

    let navigationTitle: String

    @State private var draftSelection = Set<String>()

    var body: some View {
        RecipeCategoryPickerContent(selectedCategoryIDs: $draftSelection)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        selectedCategoryIDs = draftSelection
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .fontWeight(.semibold)
                    }
                    .accessibilityLabel("Save")
                }
            }
            .onAppear {
                draftSelection = selectedCategoryIDs
            }
    }
}

struct CategoryRulesSummaryRow: View {
    @Environment(AppSettingsStore.self) private var settings

    let mandatoryCategoryIDs: [String]
    let forbiddenCategoryIDs: [String]
    let emptyLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            summaryLine(
                title: String(localized: "Mandatory"),
                categoryIDs: mandatoryCategoryIDs
            )
            summaryLine(
                title: String(localized: "Forbidden"),
                categoryIDs: forbiddenCategoryIDs
            )
        }
    }

    @ViewBuilder
    private func summaryLine(title: String, categoryIDs: [String]) -> some View {
        if categoryIDs.isEmpty {
            Text("\(title): \(emptyLabel)")
                .font(.caption)
                .foregroundStyle(.secondary)
        } else {
            Text("\(title): \(settings.labels(forTagIDs: categoryIDs).joined(separator: ", "))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct CategoryRulesEditorSection: View {
    @Environment(AppSettingsStore.self) private var settings

    @Binding var mandatoryCategoryIDs: Set<String>
    @Binding var forbiddenCategoryIDs: Set<String>

    var body: some View {
        Section {
            NavigationLink {
                CategoryIDSetEditor(
                    selectedCategoryIDs: $mandatoryCategoryIDs,
                    navigationTitle: String(localized: "Mandatory categories")
                )
            } label: {
                LabeledContent(
                    String(localized: "Mandatory"),
                    value: settings.selectionLabel(forCategoryIDs: mandatoryCategoryIDs)
                )
            }

            NavigationLink {
                CategoryIDSetEditor(
                    selectedCategoryIDs: $forbiddenCategoryIDs,
                    navigationTitle: String(localized: "Forbidden categories")
                )
            } label: {
                LabeledContent(
                    String(localized: "Forbidden"),
                    value: settings.selectionLabel(forCategoryIDs: forbiddenCategoryIDs)
                )
            }
        }
    }
}
