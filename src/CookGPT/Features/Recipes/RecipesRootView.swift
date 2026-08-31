//  RecipesRootView.swift
//  CookGPT
//
//  Recipes tab: browse, filter, favorite, and open recipes.
//

import SwiftUI
import SwiftData

private enum RecipeSortOption: String, CaseIterable {
    case alphabetical
    case difficulty
    case totalTime
    case ingredients

    var label: String {
        switch self {
        case .alphabetical: "Alphabetical"
        case .difficulty: "Difficulty"
        case .totalTime: "Total time"
        case .ingredients: "Ingredients"
        }
    }
}

struct RecipesRootView: View {
    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    @Environment(CookingSessionManager.self) private var cookingSession
    @Environment(AppSettingsStore.self) private var settings

    @State private var isAddingRecipe = false
    @State private var recipeToEdit: Recipe?
    @State private var recipeForCategories: Recipe?
    @State private var sortOption: RecipeSortOption = .alphabetical
    @State private var sortAscending = true
    @State private var selectedCategoryFilter: String?
    @State private var isEditingCategoryFilters = false
    @State private var searchText = ""

    private var sortedRecipes: [Recipe] {
        switch sortOption {
        case .alphabetical:
            recipes.sorted { compareTitles($0.title, $1.title) }
        case .difficulty:
            recipes.sorted {
                if $0.difficulty.sortOrder != $1.difficulty.sortOrder {
                    return compare($0.difficulty.sortOrder, $1.difficulty.sortOrder)
                }
                return compareTitles($0.title, $1.title)
            }
        case .totalTime:
            recipes.sorted {
                if $0.totalMinutes != $1.totalMinutes {
                    return compare($0.totalMinutes, $1.totalMinutes)
                }
                return compareTitles($0.title, $1.title)
            }
        case .ingredients:
            recipes.sorted {
                if $0.ingredients.count != $1.ingredients.count {
                    return compare($0.ingredients.count, $1.ingredients.count)
                }
                return compareTitles($0.title, $1.title)
            }
        }
    }

    private func compare<T: Comparable>(_ lhs: T, _ rhs: T) -> Bool {
        sortAscending ? lhs < rhs : lhs > rhs
    }

    private func compareTitles(_ lhs: String, _ rhs: String) -> Bool {
        let result = lhs.localizedCaseInsensitiveCompare(rhs)
        return sortAscending ? result == .orderedAscending : result == .orderedDescending
    }

    private var categoryFilteredRecipes: [Recipe] {
        guard let selectedCategoryFilter else { return sortedRecipes }
        return sortedRecipes.filter { $0.hasCategory(selectedCategoryFilter) }
    }

    private var displayedRecipes: [Recipe] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return categoryFilteredRecipes }
        return categoryFilteredRecipes.filter { recipe in
            recipe.title.localizedCaseInsensitiveContains(query)
                || recipe.summary.localizedCaseInsensitiveContains(query)
                || settings.labels(forTagIDs: recipe.tags).contains {
                    $0.localizedCaseInsensitiveContains(query)
                }
        }
    }

    private var activeDisplayedRecipes: [Recipe] {
        displayedRecipes.filter { cookingSession.isInProgress(recipe: $0) }
    }

    private var inactiveDisplayedRecipes: [Recipe] {
        displayedRecipes.filter { !cookingSession.isInProgress(recipe: $0) }
    }

    var body: some View {
        Group {
            if settings.isResettingData {
                ProgressView("Resetting app data…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if recipes.isEmpty {
                EmptyStateView(
                    systemImage: "book.closed",
                    title: "No recipes yet",
                    subtitle: "Tap + to add your first recipe."
                )
            } else {
                List {
                    Section {
                        RecipeCategoryFilterBar(
                            selectedCategoryID: $selectedCategoryFilter,
                            onEdit: { isEditingCategoryFilters = true }
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }

                    Section {
                        RecipeSearchBar(text: $searchText)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 8, trailing: 0))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }

                    if displayedRecipes.isEmpty {
                        Section {
                            ContentUnavailableView(
                                searchText.isEmpty ? "No recipes in this category" : "No matching recipes",
                                systemImage: searchText.isEmpty ? "tag.slash" : "magnifyingglass",
                                description: Text(
                                    searchText.isEmpty
                                        ? "Try another category or add tags to your recipes."
                                        : "Try a different search term."
                                )
                            )
                        }
                    } else {
                        if !activeDisplayedRecipes.isEmpty {
                            Section {
                                ForEach(activeDisplayedRecipes) { recipe in
                                    recipeListRow(recipe)
                                }
                            }
                        }

                        if !inactiveDisplayedRecipes.isEmpty {
                            Section {
                                ForEach(inactiveDisplayedRecipes) { recipe in
                                    recipeListRow(recipe)
                                }
                            }
                        }
                    }
                }
                .listSectionSpacing(8)
            }
        }
        .navigationTitle("Recipes")
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Menu {
                    Picker("Sort by", selection: $sortOption) {
                        ForEach(RecipeSortOption.allCases, id: \.self) { option in
                            Text(option.label).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .accessibilityLabel("Sort recipes")

                Button {
                    sortAscending.toggle()
                } label: {
                    Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                }
                .accessibilityLabel(sortAscending ? "Sort ascending" : "Sort descending")
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isAddingRecipe = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingRecipe) {
            RecipeEditorSheet()
        }
        .sheet(item: $recipeToEdit) { recipe in
            RecipeEditorSheet(recipe: recipe)
        }
        .sheet(item: $recipeForCategories) { recipe in
            RecipeCategoryPickerSheet(recipe: recipe)
        }
        .sheet(isPresented: $isEditingCategoryFilters) {
            RecipeCategoryFilterEditorSheet()
        }
        .onChange(of: settings.visibleRecipeFilterCategories.map(\.id)) { _, visibleIDs in
            if let selectedCategoryFilter,
               !visibleIDs.contains(selectedCategoryFilter) {
                self.selectedCategoryFilter = nil
            }
        }
        .navigationDestination(for: UUID.self) { recipeID in
            if let recipe = recipes.first(where: { $0.id == recipeID }) {
                RecipeDetailView(recipe: recipe)
            }
        }
    }

    private func toggleFavorite(_ recipe: Recipe) {
        recipe.isFavorite.toggle()
        try? modelContext.save()
    }

    @ViewBuilder
    private func recipeListRow(_ recipe: Recipe) -> some View {
        NavigationLink(value: recipe.id) {
            RecipeRowView(
                recipe: recipe,
                isInProgress: cookingSession.isInProgress(recipe: recipe)
            )
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                toggleFavorite(recipe)
            } label: {
                Label(
                    recipe.isFavorite ? "Unfavorite" : "Favorite",
                    systemImage: recipe.isFavorite ? "star.slash.fill" : "star.fill"
                )
            }
            .tint(.yellow)

            Button {
                recipeForCategories = recipe
            } label: {
                Label("Categories", systemImage: "tag")
            }
            .tint(.blue)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                deleteRecipe(id: recipe.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                recipeToEdit = recipe
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.indigo)
        }
    }

    private func deleteRecipe(id recipeID: UUID) {
        if recipeToEdit?.id == recipeID {
            recipeToEdit = nil
        }
        if recipeForCategories?.id == recipeID {
            recipeForCategories = nil
        }

        cookingSession.timerStore.stopAll(for: recipeID)

        Task { @MainActor in
            guard let recipe = recipes.first(where: { $0.id == recipeID }) else { return }
            ScheduledMeal.deleteMeals(referencing: recipeID, in: modelContext)
            modelContext.delete(recipe)
            try? modelContext.save()
        }
    }
}

private struct RecipeSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search recipes", text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemFill), in: Capsule())
    }
}

#Preview {
    NavigationStack {
        RecipesRootView()
    }
    .environment(CookingSessionManager.shared)
    .environment(AppSettingsStore.shared)
    .modelContainer(try! CookGPTModelContainer.make())
}
