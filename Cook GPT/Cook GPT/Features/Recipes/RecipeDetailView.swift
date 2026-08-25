import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    @Environment(CookingSessionManager.self) private var cookingSession
    @State private var selectedServings: Int

    init(recipe: Recipe) {
        self.recipe = recipe
        _selectedServings = State(initialValue: recipe.servings)
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
                            ForEach(recipe.tags, id: \.self) { tag in
                                Text(tag)
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
    }
}

enum QuantityFormatter {
    static func string(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.1f", value)
    }
}
