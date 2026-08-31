//  RecipeRowView.swift
//  CookGPT
//
//  Shared recipe list row used on Recipes and Meals screens.
//

import SwiftUI

struct RecipeMetaItem: View {
    let systemImage: String
    let text: String

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: systemImage)
            Text(text)
        }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe
    var isInProgress: Bool = false
    var showsSummary: Bool = true
    var servings: Int? = nil
    @Environment(AppSettingsStore.self) private var settings

    private var displayedServings: Int {
        servings ?? recipe.servings
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if isInProgress {
                    Image(systemName: "timer")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.15))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                        .accessibilityLabel("Timer running")
                }
                Text(recipe.title)
                    .font(.headline)
                if recipe.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }
            }
            if showsSummary, !recipe.summary.isEmpty {
                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(spacing: 10) {
                RecipeMetaItem(systemImage: "clock", text: "\(recipe.totalMinutes) min")
                    .accessibilityLabel("\(recipe.totalMinutes) minutes")
                RecipeMetaItem(systemImage: "fork.knife", text: "\(displayedServings)")
                    .accessibilityLabel("\(displayedServings) servings")
                RecipeMetaItem(systemImage: "list.bullet", text: "\(recipe.ingredients.count)")
                    .accessibilityLabel("\(recipe.ingredients.count) ingredients")
                DifficultyBadge(difficulty: recipe.difficulty)
                RecipeCookingToolsBadgeRow(tools: recipe.selectedCookingTools)
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 4)
    }
}
