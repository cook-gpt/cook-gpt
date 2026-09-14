//  RecipeCategoryViews.swift
//  CookGPT
//
//  Category filter chips, compact selection, and searchable picker.
//

import SwiftData
import SwiftUI

struct RecipeCategorySelectionSection: View {
    @Binding var selectedCategoryIDs: Set<String>
    @Environment(AppSettingsStore.self) private var settings

    private var selectedCategories: [AppCategory] {
        settings.allCategories.filter { selectedCategoryIDs.contains($0.id) }
    }

    var body: some View {
        Section {
            NavigationLink {
                RecipeCategoryPickerContent(selectedCategoryIDs: $selectedCategoryIDs)
                    .navigationTitle("Categories")
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                categorySelectionLabel
            }
        } header: {
            Text("Categories")
        } footer: {
            Text("Organize recipes for browsing and meal planning.")
        }
    }

    @ViewBuilder
    private var categorySelectionLabel: some View {
        if selectedCategories.isEmpty {
            Text("Add categories")
                .foregroundStyle(.secondary)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(selectedCategories) { category in
                        CategoryChip(title: category.label, style: .selected)
                    }
                }
            }
        }
    }
}

struct RecipeCategoryPickerContent: View {
    @Binding var selectedCategoryIDs: Set<String>
    @Environment(AppSettingsStore.self) private var settings
    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @State private var searchText = ""

    private var orderedCategories: [AppCategory] {
        let byID = Dictionary(uniqueKeysWithValues: settings.allCategories.map { ($0.id, $0) })
        return settings.categoryIDsInDisplayOrder().compactMap { byID[$0] }
    }

    private var filteredCategories: [AppCategory] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return orderedCategories }
        return orderedCategories.filter { category in
            category.label.localizedCaseInsensitiveContains(query)
                || category.id.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        List {
            if filteredCategories.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                ForEach(filteredCategories) { category in
                    RecipeCategoryChecklistRow(
                        label: category.label,
                        isSelected: selectedCategoryIDs.contains(category.id),
                        recipeCount: recipeCount(for: category.id),
                        onToggle: { toggle(category.id) }
                    )
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search categories")
        .onAppear {
            settings.ensureCategoriesExist(tagIDs: Set(recipes.flatMap(\.tags)))
        }
    }

    private func recipeCount(for categoryID: String) -> Int {
        recipes.count { $0.tags.contains(categoryID) }
    }

    private func toggle(_ categoryID: String) {
        if selectedCategoryIDs.contains(categoryID) {
            selectedCategoryIDs.remove(categoryID)
        } else {
            selectedCategoryIDs.insert(categoryID)
        }
    }
}

struct RecipeCategoryChecklistRow: View {
    let label: String
    let isSelected: Bool
    let recipeCount: Int
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .green : .secondary)

                Text(label)

                Spacer(minLength: 8)

                Text(String(format: String(localized: "Recipes: %lld"), recipeCount))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 2)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}

struct RecipeCategoryFilterBar: View {
    @Binding var selectedCategoryID: String?
    var onEdit: () -> Void
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryFilterChip(
                    title: "All",
                    isSelected: selectedCategoryID == nil
                ) {
                    selectedCategoryID = nil
                }

                ForEach(settings.visibleRecipeFilterCategories) { category in
                    CategoryFilterChip(
                        title: category.label,
                        isSelected: selectedCategoryID == category.id
                    ) {
                        selectedCategoryID = category.id
                    }
                }

                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemFill))
                    .foregroundStyle(.primary)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Edit categories")
            }
        }
    }
}

private struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            CategoryChip(title: title, style: isSelected ? .filterSelected : .filter)
        }
        .buttonStyle(.plain)
    }
}

private struct CategoryChip: View {
    enum Style {
        case selected
        case filter
        case filterSelected
    }

    let title: String
    let style: Style

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch style {
        case .selected:
            Color(.secondarySystemFill)
        case .filter:
            Color(.secondarySystemFill)
        case .filterSelected:
            Color.accentColor
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .selected, .filter:
            Color.primary
        case .filterSelected:
            Color.white
        }
    }
}
