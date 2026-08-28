//  RecipeCategoryViews.swift
//  CookGPT
//
//  Category filter chips and tag toggle section.
//

import SwiftUI

struct RecipeCategoryToggleSection: View {
    @Binding var selectedCategoryIDs: Set<String>
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        Section("Categories") {
            ForEach(settings.allCategories) { category in
                Toggle(isOn: binding(for: category.id)) {
                    Text(category.label)
                }
            }
        }
    }

    private func binding(for categoryID: String) -> Binding<Bool> {
        Binding(
            get: { selectedCategoryIDs.contains(categoryID) },
            set: { isOn in
                if isOn {
                    selectedCategoryIDs.insert(categoryID)
                } else {
                    selectedCategoryIDs.remove(categoryID)
                }
            }
        )
    }
}

struct RecipeCategoryFilterBar: View {
    @Binding var selectedCategoryID: String?
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

                ForEach(settings.allCategories) { category in
                    CategoryFilterChip(
                        title: category.label,
                        isSelected: selectedCategoryID == category.id
                    ) {
                        selectedCategoryID = category.id
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

private struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemFill))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
