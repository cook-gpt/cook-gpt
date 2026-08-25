import SwiftUI
import SwiftData

struct LogMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Recipe.title) private var recipes: [Recipe]

    @State private var mealType: MealType = .lunch
    @State private var calories = 400
    @State private var selectedRecipeID: UUID?
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Picker("Meal", selection: $mealType) {
                    ForEach(MealType.allCases, id: \.self) { type in
                        Text(type.label).tag(type)
                    }
                }

                Stepper("Calories: \(calories)", value: $calories, in: 0...5000, step: 50)

                Picker("Recipe", selection: $selectedRecipeID) {
                    Text("None").tag(UUID?.none)
                    ForEach(recipes) { recipe in
                        Text(recipe.title).tag(Optional(recipe.id))
                    }
                }

                TextField("Note", text: $note, axis: .vertical)
                    .lineLimit(2...4)
            }
            .navigationTitle("Log meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func save() {
        let recipe = recipes.first { $0.id == selectedRecipeID }
        let entry = MealLogEntry(
            mealType: mealType,
            calories: calories,
            recipe: recipe,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        modelContext.insert(entry)
        try? modelContext.save()
        dismiss()
    }
}
