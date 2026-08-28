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

    @Bindable var recipe: Recipe
    @State private var selectedCategoryIDs: Set<String> = []

    var body: some View {
        NavigationStack {
            Form {
                RecipeCategoryToggleSection(selectedCategoryIDs: $selectedCategoryIDs)
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear {
                selectedCategoryIDs = Set(recipe.tags)
            }
        }
    }

    private func save() {
        recipe.tags = selectedCategoryIDs.sorted()
        try? modelContext.save()
        dismiss()
    }
}
