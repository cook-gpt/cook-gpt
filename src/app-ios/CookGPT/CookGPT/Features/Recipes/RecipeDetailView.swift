//  RecipeDetailView.swift
//  CookGPT
//
//  Recipe detail with scaled ingredients, steps, share, and timers.
//

import SwiftUI
import SwiftData

private enum RecipeScrollAnchor {
    static let stepsSection = "recipe-steps-section"
}

struct RecipeDetailView: View {
    let recipe: Recipe

    @Query(sort: \GroceryList.name) private var groceryLists: [GroceryList]
    @Environment(\.modelContext) private var modelContext
    @Environment(CookingSessionManager.self) private var cookingSession
    @Environment(AppSettingsStore.self) private var settings
    @Environment(AppNavigationStore.self) private var navigation
    @State private var selectedServings: Int
    @State private var isEditingRecipe = false

    private var primaryGroceryList: GroceryList? {
        groceryLists.first
    }

    private var canAddToGroceries: Bool {
        primaryGroceryList != nil && !recipe.ingredients.isEmpty
    }

    init(recipe: Recipe, initialServings: Int? = nil) {
        self.recipe = recipe
        _selectedServings = State(initialValue: initialServings ?? recipe.servings)
        _groceryLists = Query(sort: \GroceryList.name)
    }

    private var shareText: String {
        RecipeShareFormatter.text(for: recipe, servings: selectedServings)
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
        List {
            Section {
                Text(recipe.summary)
                    .foregroundStyle(.secondary)

                Stepper(value: $selectedServings, in: 1...24) {
                    LabeledContent(String(localized: "Servings"), value: "\(selectedServings)")
                }

                LabeledContent(
                    String(localized: "Prep"),
                    value: String(format: String(localized: "%lld min"), recipe.prepMinutes)
                )
                LabeledContent(
                    String(localized: "Cook"),
                    value: String(format: String(localized: "%lld min"), recipe.cookMinutes)
                )

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

            Section {
                ForEach(recipe.ingredients, id: \.persistentModelID) { item in
                    let scaled = recipe.scaledQuantity(item.quantity, servings: selectedServings)
                    Text("\(QuantityFormatter.string(scaled)) \(IngredientUnitFormatting.localizedLabel(for: item.unit, quantity: scaled)) \(item.displayName)")
                }
            } header: {
                HStack(spacing: 8) {
                    Text("Ingredients")
                    Spacer(minLength: 8)
                    Button("+ Add to groceries list") {
                        addToGroceries()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .buttonStyle(.plain)
                    .disabled(!canAddToGroceries)
                }
                .textCase(nil)
            }

            Section("Steps") {
                ForEach(Array(recipe.sortedSteps.enumerated()), id: \.element.id) { index, step in
                    RecipeStepRowView(
                        step: step,
                        stepNumber: index + 1,
                        recipe: recipe,
                        cookingSession: cookingSession
                    )
                    .id(step.id)
                }
            }
            .id(RecipeScrollAnchor.stepsSection)
        }
        .onAppear {
            scrollToPendingTarget(using: scrollProxy)
        }
        .onChange(of: navigation.pendingRecipeScrollRequest) { _, request in
            guard request?.recipeID == recipe.id else { return }
            scrollToPendingTarget(using: scrollProxy)
        }
        }
        .navigationTitle(recipe.title)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                ShareLink(
                    item: shareText,
                    subject: Text(recipe.title)
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Share recipe")

                Button {
                    isEditingRecipe = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel("Edit")
            }
        }
        .sheet(isPresented: $isEditingRecipe) {
            RecipeEditorSheet(recipe: recipe)
        }
    }

    private func scrollToPendingTarget(using scrollProxy: ScrollViewProxy) {
        guard let request = navigation.consumePendingRecipeScrollRequest(for: recipe.id) else { return }

        let target: AnyHashable
        if let stepID = request.stepID, recipe.sortedSteps.contains(where: { $0.id == stepID }) {
            target = stepID
        } else {
            target = RecipeScrollAnchor.stepsSection
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(150))
            withAnimation {
                scrollProxy.scrollTo(target, anchor: .top)
            }
        }
    }

    private func addToGroceries() {
        guard let list = primaryGroceryList else { return }

        let imported = ShoppingListGenerator.aggregate(
            recipes: [(recipe: recipe, servings: selectedServings)]
        )
        let finalItems = ShoppingListGenerator.merge(aggregated: imported, with: list.items)

        list.items.forEach { modelContext.delete($0) }
        list.items = []

        for item in finalItems {
            let groceryItem = GroceryItem(
                name: item.name,
                quantity: item.quantity,
                unit: item.unit,
                isChecked: item.isChecked,
                sortOrder: 0,
                list: list
            )
            modelContext.insert(groceryItem)
            list.items.append(groceryItem)
        }

        list.normalizePartitionedSortOrders()

        let sourceDescription = recipe.title
        if list.sourceDescription.isEmpty {
            list.sourceDescription = sourceDescription
        } else {
            list.sourceDescription = "\(list.sourceDescription) + \(sourceDescription)"
        }
        list.generatedAt = .now
        try? modelContext.save()

        navigation.openGroceries(highlightingItemKeys: Set(imported.map(\.identityKey)))
    }
}
