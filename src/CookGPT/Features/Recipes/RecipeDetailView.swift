//  RecipeDetailView.swift
//  CookGPT
//
//  Recipe detail with scaled ingredients, steps, share, and timers.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipe: Recipe

    @Environment(CookingSessionManager.self) private var cookingSession
    @Environment(AppSettingsStore.self) private var settings
    @State private var selectedServings: Int
    @State private var isEditingRecipe = false

    init(recipe: Recipe) {
        self.recipe = recipe
        _selectedServings = State(initialValue: recipe.servings)
    }

    private var shareText: String {
        RecipeShareFormatter.text(for: recipe, servings: selectedServings)
    }

    var body: some View {
        List {
            Section {
                Text(recipe.summary)
                    .foregroundStyle(.secondary)

                Stepper(value: $selectedServings, in: 1...24) {
                    LabeledContent("Servings", value: "\(selectedServings)")
                }

                LabeledContent("Prep", value: "\(recipe.prepMinutes) min")
                LabeledContent("Cook", value: "\(recipe.cookMinutes) min")

                if !recipe.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(settings.labels(forTagIDs: recipe.tags), id: \.self) { label in
                                Text(label)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.quaternary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }

            if selectedServings != recipe.servings {
                Section {
                    Text("Quantities scaled for \(selectedServings) servings (recipe serves \(recipe.servings)).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Ingredients") {
                ForEach(recipe.ingredients, id: \.persistentModelID) { item in
                    let scaled = recipe.scaledQuantity(item.quantity, servings: selectedServings)
                    Text("\(QuantityFormatter.string(scaled)) \(item.unit) \(item.displayName)")
                }
            }

            Section("Steps") {
                ForEach(Array(recipe.sortedSteps.enumerated()), id: \.element.id) { index, step in
                    RecipeStepRowView(
                        step: step,
                        stepNumber: index + 1,
                        recipe: recipe,
                        cookingSession: cookingSession
                    )
                }
            }
        }
        .navigationTitle(recipe.title)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(
                    item: shareText,
                    subject: Text(recipe.title),
                    message: Text(shareText)
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share recipe")

                Button("Edit") {
                    isEditingRecipe = true
                }
            }
        }
        .sheet(isPresented: $isEditingRecipe) {
            RecipeEditorSheet(recipe: recipe)
        }
    }
}
