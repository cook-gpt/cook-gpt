//  RecipeCategoryFilterEditorSheet.swift
//  CookGPT
//
//  Configure visible recipe category filters, order, and categories.
//

import SwiftData
import SwiftUI

struct RecipeCategoryFilterEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettingsStore.self) private var settings
    @Query(sort: \Recipe.title) private var recipes: [Recipe]

    @State private var orderedCategoryIDs: [String] = []
    @State private var activeCategoryIDs: Set<String> = []
    @State private var isAddingCategory = false
    @State private var newCategoryLabel = ""
    @State private var listEditMode: EditMode = .inactive

    private var isEditing: Bool {
        listEditMode == .active
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if orderedCategoryIDs.isEmpty {
                        Text("No categories yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(orderedCategoryIDs, id: \.self) { categoryID in
                            RecipeCategoryFilterRow(
                                label: settings.label(forCategoryID: categoryID),
                                isActive: activeCategoryIDs.contains(categoryID),
                                recipeCount: recipeCount(for: categoryID),
                                isEditing: isEditing,
                                onToggleActive: { toggleCategory(categoryID) },
                                onDelete: { deleteCategory(categoryID) }
                            )
                        }
                        .onMove(perform: moveCategories)
                    }

                    Button {
                        newCategoryLabel = ""
                        isAddingCategory = true
                    } label: {
                        Label("Add category", systemImage: "plus")
                    }
                } footer: {
                    if isEditing {
                        Text("Drag to set the order shown on Recipes. Tap the red button to delete a category.")
                    } else {
                        Text("Checked categories appear in the Recipes filter bar.")
                    }
                }
            }
            .navigationTitle("Edit categories")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, $listEditMode)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                    }
                    .accessibilityLabel("Back")
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        listEditMode = listEditMode == .active ? .inactive : .active
                    } label: {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                    }
                    .accessibilityLabel(isEditing ? "Done editing" : "Edit categories")
                }
            }
            .onAppear {
                reloadCategoryState()
            }
            .alert("Add category", isPresented: $isAddingCategory) {
                TextField("Category name", text: $newCategoryLabel)
                Button("Cancel", role: .cancel) {}
                Button("Add") {
                    addCategory()
                }
            }
        }
    }

    private func reloadCategoryState() {
        activeCategoryIDs = Set(settings.effectiveRecipeFilterActiveCategoryIDs())
        orderedCategoryIDs = settings.effectiveRecipeFilterActiveCategoryIDs()
            + settings.inactiveRecipeFilterCategoryIDs()
    }

    private func recipeCount(for categoryID: String) -> Int {
        recipes.count { $0.tags.contains(categoryID) }
    }

    private func toggleCategory(_ categoryID: String) {
        if activeCategoryIDs.contains(categoryID) {
            activeCategoryIDs.remove(categoryID)
        } else {
            activeCategoryIDs.insert(categoryID)
        }
        saveActiveFilter()
    }

    private func moveCategories(from source: IndexSet, to destination: Int) {
        orderedCategoryIDs.move(fromOffsets: source, toOffset: destination)
        saveActiveFilter()
    }

    private func addCategory() {
        guard settings.addCategory(label: newCategoryLabel) else { return }

        let newIDs = settings.allCategories.map(\.id).filter { !orderedCategoryIDs.contains($0) }
        orderedCategoryIDs.append(contentsOf: newIDs)
        activeCategoryIDs.formUnion(newIDs)
        saveActiveFilter()
    }

    private func deleteCategory(_ categoryID: String) {
        settings.removeCategory(id: categoryID)
        orderedCategoryIDs.removeAll { $0 == categoryID }
        activeCategoryIDs.remove(categoryID)
        saveActiveFilter()
    }

    private func saveActiveFilter() {
        let orderedActive = orderedCategoryIDs.filter { activeCategoryIDs.contains($0) }
        if orderedActive.count == settings.allCategories.count {
            settings.setRecipeFilterActiveCategoryIDs([])
        } else {
            settings.setRecipeFilterActiveCategoryIDs(orderedActive)
        }
    }
}

private struct RecipeCategoryFilterRow: View {
    let label: String
    let isActive: Bool
    let recipeCount: Int
    let isEditing: Bool
    let onToggleActive: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if isEditing {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Delete \(label)")
            } else {
                Button(action: onToggleActive) {
                    Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(isActive ? .green : .secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isActive ? "Hide \(label) from filter bar" : "Show \(label) in filter bar")
            }

            Text(label)

            Spacer(minLength: 8)

            if !isEditing {
                Text("Recipes: \(recipeCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("\(recipeCount) recipes")
            }
        }
        .padding(.vertical, 2)
    }
}
