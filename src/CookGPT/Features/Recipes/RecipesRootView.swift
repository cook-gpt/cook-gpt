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

    private var filteredRecipes: [Recipe] {
        guard let selectedCategoryFilter else { return sortedRecipes }
        return sortedRecipes.filter { $0.hasCategory(selectedCategoryFilter) }
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
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                    }

                    if filteredRecipes.isEmpty {
                        ContentUnavailableView(
                            "No recipes in this category",
                            systemImage: "tag.slash",
                            description: Text("Try another category or add tags to your recipes.")
                        )
                    } else {
                        ForEach(filteredRecipes) { recipe in
                            NavigationLink(value: recipe) {
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
                                    deleteRecipe(recipe)
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
                    }
                }
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
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }

    private func toggleFavorite(_ recipe: Recipe) {
        recipe.isFavorite.toggle()
        try? modelContext.save()
    }

    private func deleteRecipe(_ recipe: Recipe) {
        cookingSession.timerStore.stopAll(for: recipe.id)
        modelContext.delete(recipe)
        try? modelContext.save()
    }
}

private struct RecipeMetaItem: View {
    let systemImage: String
    let text: String

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: systemImage)
            Text(text)
        }
    }
}

private struct RecipeRowView: View {
    let recipe: Recipe
    var isInProgress: Bool = false
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(recipe.title)
                    .font(.headline)
                if recipe.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }
                if isInProgress {
                    Text("Timer running")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
            }
            Text(recipe.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack(spacing: 10) {
                RecipeMetaItem(systemImage: "clock", text: "\(recipe.totalMinutes) min")
                    .accessibilityLabel("\(recipe.totalMinutes) minutes")
                RecipeMetaItem(systemImage: "fork.knife", text: "\(recipe.servings)")
                    .accessibilityLabel("\(recipe.servings) servings")
                RecipeMetaItem(systemImage: "list.bullet", text: "\(recipe.ingredients.count)")
                    .accessibilityLabel("\(recipe.ingredients.count) ingredients")
                DifficultyBadge(difficulty: recipe.difficulty)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if !recipe.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(settings.labels(forTagIDs: recipe.tags), id: \.self) { label in
                            Text(label)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(.quaternary)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
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
