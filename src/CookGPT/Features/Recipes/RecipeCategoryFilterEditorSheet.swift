//  RecipeCategoryFilterEditorSheet.swift
//  CookGPT
//
//  Configure visible recipe category filters, order, and categories.
//

import SwiftUI

struct RecipeCategoryFilterEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettingsStore.self) private var settings

    @State private var activeCategoryIDs: [String] = []
    @State private var isAddingCategory = false
    @State private var newCategoryLabel = ""

    private var inactiveCategoryIDs: [String] {
        let active = Set(activeCategoryIDs)
        return settings.allCategories.map(\.id).filter { !active.contains($0) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if activeCategoryIDs.isEmpty {
                        Text("No active categories.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(activeCategoryIDs, id: \.self) { categoryID in
                            categoryRow(
                                categoryID: categoryID,
                                isActive: true
                            )
                        }
                        .onDelete(perform: deleteActiveCategories)
                        .onMove(perform: moveActiveCategories)
                    }
                } header: {
                    Text("Active")
                } footer: {
                    Text("Drag to set the order shown on Recipes.")
                }

                Section {
                    if inactiveCategoryIDs.isEmpty, settings.allCategories.isEmpty {
                        Text("No categories yet.")
                            .foregroundStyle(.secondary)
                    } else if inactiveCategoryIDs.isEmpty {
                        Text("All categories are active.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(inactiveCategoryIDs, id: \.self) { categoryID in
                            categoryRow(
                                categoryID: categoryID,
                                isActive: false
                            )
                        }
                        .onDelete(perform: deleteInactiveCategories)
                    }

                    Button {
                        newCategoryLabel = ""
                        isAddingCategory = true
                    } label: {
                        Label("Add category", systemImage: "plus")
                    }
                } header: {
                    Text("List")
                } footer: {
                    Text("Swipe left to delete a category.")
                }
            }
            .navigationTitle("Edit categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
            }
            .onAppear {
                activeCategoryIDs = settings.effectiveRecipeFilterActiveCategoryIDs()
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

    @ViewBuilder
    private func categoryRow(categoryID: String, isActive: Bool) -> some View {
        HStack {
            Text(settings.label(forCategoryID: categoryID))
            Spacer()
            Toggle(
                "Active",
                isOn: Binding(
                    get: { isActive },
                    set: { isOn in
                        setCategory(categoryID, isActive: isOn)
                    }
                )
            )
            .labelsHidden()
        }
    }

    private func setCategory(_ categoryID: String, isActive: Bool) {
        if isActive {
            guard !activeCategoryIDs.contains(categoryID) else { return }
            activeCategoryIDs.append(categoryID)
        } else {
            activeCategoryIDs.removeAll { $0 == categoryID }
        }
        settings.setRecipeFilterActiveCategoryIDs(activeCategoryIDs)
    }

    private func moveActiveCategories(from source: IndexSet, to destination: Int) {
        activeCategoryIDs.move(fromOffsets: source, toOffset: destination)
        settings.setRecipeFilterActiveCategoryIDs(activeCategoryIDs)
    }

    private func addCategory() {
        guard settings.addCategory(label: newCategoryLabel) else { return }
        if !settings.recipeFilterActiveCategoryIDs.isEmpty {
            activeCategoryIDs = settings.effectiveRecipeFilterActiveCategoryIDs()
        }
    }

    private func deleteActiveCategories(at offsets: IndexSet) {
        for index in offsets {
            guard activeCategoryIDs.indices.contains(index) else { continue }
            deleteCategory(activeCategoryIDs[index])
        }
    }

    private func deleteInactiveCategories(at offsets: IndexSet) {
        for index in offsets {
            guard inactiveCategoryIDs.indices.contains(index) else { continue }
            deleteCategory(inactiveCategoryIDs[index])
        }
    }

    private func deleteCategory(_ categoryID: String) {
        settings.removeCategory(id: categoryID)
        activeCategoryIDs.removeAll { $0 == categoryID }
        settings.setRecipeFilterActiveCategoryIDs(activeCategoryIDs)
    }
}
