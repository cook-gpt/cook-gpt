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
    @State private var sortOption: RecipeSortOption = .alphabetical

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

    var body: some View {
        Group {
            if recipes.isEmpty {
                EmptyStateView(
                    systemImage: "book.closed",
                    title: "No recipes yet",
                    subtitle: "Sample recipes will appear on first launch."
                )
            } else {
                List {
                    ForEach(sortedRecipes) { recipe in
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
                        }
                    }
                    .onDelete(perform: deleteRecipes)
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
            AddRecipeSheet()
        }
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }

    private func toggleFavorite(_ recipe: Recipe) {
        recipe.isFavorite.toggle()
        try? modelContext.save()
    }

    private func deleteRecipes(at offsets: IndexSet) {
        for index in offsets {
            let recipe = sortedRecipes[index]
            cookingSession.timerStore.stopAll(for: recipe.id)
            modelContext.delete(recipe)
        }
        try? modelContext.save()
    }
}

private struct RecipeRowView: View {
    let recipe: Recipe
    var isInProgress: Bool = false

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
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        RecipesRootView()
    }
    .environment(CookingSessionManager.shared)
    .modelContainer(try! CookGPTModelContainer.make())
}
