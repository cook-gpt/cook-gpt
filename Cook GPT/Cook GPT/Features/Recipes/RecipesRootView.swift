import SwiftUI
import SwiftData

private enum RecipeSortOption: String, CaseIterable {
    case alphabetical
    case difficulty
    case totalTime

    var label: String {
        switch self {
        case .alphabetical: "Alphabetical"
        case .difficulty: "Difficulty"
        case .totalTime: "Total time"
        }
    }
}

struct RecipesRootView: View {
    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    @Environment(CookingSessionManager.self) private var cookingSession

    @State private var isAddingRecipe = false
    @State private var recipeToEdit: Recipe?
    @State private var recipeForCategories: Recipe?
    @State private var sortOption: RecipeSortOption = .alphabetical
    @State private var selectedCategoryFilter: String?

    private var sortedRecipes: [Recipe] {
        switch sortOption {
        case .alphabetical:
            recipes.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .difficulty:
            recipes.sorted {
                if $0.difficulty.sortOrder != $1.difficulty.sortOrder {
                    return $0.difficulty.sortOrder < $1.difficulty.sortOrder
                }
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .totalTime:
            recipes.sorted {
                if $0.totalMinutes != $1.totalMinutes {
                    return $0.totalMinutes < $1.totalMinutes
                }
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        }
    }

    private var filteredRecipes: [Recipe] {
        guard let selectedCategoryFilter else { return sortedRecipes }
        return sortedRecipes.filter { $0.hasCategory(selectedCategoryFilter) }
    }

    var body: some View {
        Group {
            if recipes.isEmpty {
                EmptyStateView(
                    systemImage: "book.closed",
                    title: "No recipes yet",
                    subtitle: "Tap + to add your first recipe."
                )
            } else {
                List {
                    Section {
                        RecipeCategoryFilterBar(selectedCategoryID: $selectedCategoryFilter)
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
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Picker("Sort by", selection: $sortOption) {
                        ForEach(RecipeSortOption.allCases, id: \.self) { option in
                            Text(option.label).tag(option)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
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
            HStack {
                Label("\(recipe.totalMinutes) min", systemImage: "clock")
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
