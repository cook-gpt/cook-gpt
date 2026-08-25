import SwiftUI
import SwiftData

struct AddRecipeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var summary = ""
    @State private var servings = 4
    @State private var prepMinutes = 15
    @State private var cookMinutes = 30
    @State private var difficulty: RecipeDifficulty = .medium
    @State private var ingredients: [DraftIngredient] = [DraftIngredient()]
    @State private var steps: [DraftStep] = [DraftStep()]

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Summary", text: $summary, axis: .vertical)
                        .lineLimit(2...4)

                    Stepper("Servings: \(servings)", value: $servings, in: 1...24)
                    Stepper("Prep: \(prepMinutes) min", value: $prepMinutes, in: 0...240, step: 5)
                    Stepper("Cook: \(cookMinutes) min", value: $cookMinutes, in: 0...480, step: 5)

                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(RecipeDifficulty.allCases, id: \.self) { level in
                            Text(level.label).tag(level)
                        }
                    }
                }

                Section {
                    ForEach($ingredients) { $ingredient in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Ingredient name", text: $ingredient.name)
                            HStack {
                                Stepper(
                                    QuantityFormatter.string(ingredient.quantity),
                                    value: $ingredient.quantity,
                                    in: 0.1...1000,
                                    step: 0.5
                                )
                                TextField("Unit", text: $ingredient.unit)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(maxWidth: 80)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: deleteIngredients)

                    Button {
                        ingredients.append(DraftIngredient())
                    } label: {
                        Label("Add ingredient", systemImage: "plus")
                    }
                } header: {
                    Text("Ingredients")
                }

                Section {
                    ForEach($steps) { $step in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Instruction", text: $step.instruction, axis: .vertical)
                                .lineLimit(2...5)

                            Toggle("Timer", isOn: $step.hasTimer)
                            if step.hasTimer {
                                Stepper("Duration: \(step.timerMinutes) min", value: $step.timerMinutes, in: 1...180)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: deleteSteps)

                    Button {
                        steps.append(DraftStep())
                    } label: {
                        Label("Add step", systemImage: "plus")
                    }
                } header: {
                    Text("Steps")
                }
            }
            .navigationTitle("Add recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func deleteIngredients(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
        if ingredients.isEmpty {
            ingredients.append(DraftIngredient())
        }
    }

    private func deleteSteps(at offsets: IndexSet) {
        steps.remove(atOffsets: offsets)
        if steps.isEmpty {
            steps.append(DraftStep())
        }
    }

    private func save() {
        let recipe = Recipe(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            summary: summary.trimmingCharacters(in: .whitespacesAndNewlines),
            servings: servings,
            prepMinutes: prepMinutes,
            cookMinutes: cookMinutes,
            difficulty: difficulty
        )
        modelContext.insert(recipe)

        let savedIngredients = ingredients.compactMap { draft -> RecipeIngredient? in
            let name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { return nil }

            let ingredient = findOrCreateIngredient(named: name)
            let recipeIngredient = RecipeIngredient(
                quantity: draft.quantity,
                unit: draft.unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "pcs" : draft.unit,
                ingredient: ingredient,
                recipe: recipe
            )
            modelContext.insert(recipeIngredient)
            return recipeIngredient
        }
        recipe.ingredients = savedIngredients

        var stepOrder = 0
        let savedSteps = steps.compactMap { draft -> RecipeStep? in
            let instruction = draft.instruction.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !instruction.isEmpty else { return nil }

            let step = RecipeStep(
                order: stepOrder,
                instruction: instruction,
                timerSeconds: draft.hasTimer ? draft.timerMinutes * 60 : nil,
                recipe: recipe
            )
            stepOrder += 1
            modelContext.insert(step)
            return step
        }
        recipe.steps = savedSteps

        try? modelContext.save()
        dismiss()
    }

    private func findOrCreateIngredient(named name: String) -> Ingredient {
        let descriptor = FetchDescriptor<Ingredient>()
        let existing = (try? modelContext.fetch(descriptor)) ?? []
        if let match = existing.first(where: { $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame }) {
            return match
        }

        let ingredient = Ingredient(name: name, category: .other)
        modelContext.insert(ingredient)
        return ingredient
    }
}

private struct DraftIngredient: Identifiable {
    let id = UUID()
    var name = ""
    var quantity = 1.0
    var unit = "pcs"
}

private struct DraftStep: Identifiable {
    let id = UUID()
    var instruction = ""
    var hasTimer = false
    var timerMinutes = 5
}
