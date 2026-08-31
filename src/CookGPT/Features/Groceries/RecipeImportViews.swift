//  RecipeImportViews.swift
//  CookGPT
//
//  Recipe picker and import row used in groceries edit mode.
//

import SwiftUI

enum RecipeImportRowLayout {
    static let stepperWidth: CGFloat = 96
    static let chevronWidth: CGFloat = 12
    static let rowSpacing: CGFloat = 4
    static let columnSpacing: CGFloat = 8
}

struct RecipeImportEntryRow: View {
    @Binding var recipeID: UUID?
    @Binding var servings: Int
    let recipes: [Recipe]
    let onOpenPicker: () -> Void

    private var recipe: Recipe? {
        guard let recipeID else { return nil }
        return recipes.first { $0.id == recipeID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: RecipeImportRowLayout.rowSpacing) {
            HStack(alignment: .center, spacing: RecipeImportRowLayout.columnSpacing) {
                Button(action: onOpenPicker) {
                    Text(recipe?.title ?? "Select recipe")
                        .foregroundStyle(recipe == nil ? .secondary : .primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .frame(width: RecipeImportRowLayout.chevronWidth)

                servingsStepper
            }

            if let recipe {
                HStack(alignment: .center, spacing: RecipeImportRowLayout.columnSpacing) {
                    Text("Ingredients: \(recipe.ingredients.count)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Color.clear
                        .frame(width: RecipeImportRowLayout.chevronWidth)

                    Text("Servings: \(servings)")
                        .frame(width: RecipeImportRowLayout.stepperWidth, alignment: .trailing)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private var servingsStepper: some View {
        Stepper("", value: $servings, in: 1...24)
            .labelsHidden()
            .disabled(recipe == nil)
            .frame(width: RecipeImportRowLayout.stepperWidth, alignment: .trailing)
    }
}

struct RecipeImportPickerContent: View {
    let recipes: [Recipe]
    let excludedRecipeIDs: Set<UUID>
    let onSelect: (Recipe) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var availableRecipes: [Recipe] {
        recipes.filter { !excludedRecipeIDs.contains($0.id) }
    }

    private var filteredRecipes: [Recipe] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return availableRecipes }
        return availableRecipes.filter { recipe in
            recipe.title.localizedCaseInsensitiveContains(query)
                || recipe.summary.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        List {
            if availableRecipes.isEmpty {
                ContentUnavailableView(
                    "No recipes left",
                    systemImage: "book.closed",
                    description: Text("All available recipes are already in your import list.")
                )
            } else if filteredRecipes.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                ForEach(filteredRecipes) { recipe in
                    Button {
                        onSelect(recipe)
                        dismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(recipe.title)
                            Text(recipePickerSubtitle(recipe))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search recipes")
    }

    private func recipePickerSubtitle(_ recipe: Recipe) -> String {
        let ingredientCount = recipe.ingredients.count
        let ingredientLabel = ingredientCount == 1 ? "1 ingredient" : "\(ingredientCount) ingredients"
        return "Serves \(recipe.servings) · \(ingredientLabel)"
    }
}
