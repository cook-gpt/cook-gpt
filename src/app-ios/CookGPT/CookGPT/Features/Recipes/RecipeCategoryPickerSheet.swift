//  RecipeCategoryPickerSheet.swift
//  CookGPT
//
//  Sheet to edit category tags on a recipe.
//

import SwiftUI
import SwiftData

struct RecipeCategoryPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @Bindable var recipe: Recipe
    @State private var selectedCategoryIDs: Set<String> = []

    var body: some View {
        NavigationStack {
            RecipeCategoryPickerContent(selectedCategoryIDs: $selectedCategoryIDs)
                .navigationTitle("Categories")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .accessibilityLabel(String(localized: "Cancel"))
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            save()
                        } label: {
                            Image(systemName: "checkmark")
                                .fontWeight(.semibold)
                        }
                        .accessibilityLabel(String(localized: "Save"))
                    }
                }
                .onAppear {
                    selectedCategoryIDs = Set(recipe.tags)
                }
        }
    }

    private func save() {
        recipe.tags = selectedCategoryIDs.sorted()
        settings.ensureCategoriesExist(tagIDs: selectedCategoryIDs)
        try? modelContext.save()
        dismiss()
    }
}
