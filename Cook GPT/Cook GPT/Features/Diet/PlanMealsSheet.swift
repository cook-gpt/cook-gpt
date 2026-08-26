import SwiftUI
import SwiftData

struct PlanMealsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    let profile: DietProfile

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]

    @State private var startDate = Date()
    @State private var numberOfDays = 7
    @State private var servings = 1

    private var eligibleCount: Int {
        MealPlanner.eligibleRecipes(dietType: profile.dietType, from: recipes).count
    }

    private var plannedSlotsDescription: String {
        if settings.includeBreakfastInMealPrep {
            return "Breakfast, lunch, and dinner"
        }
        return "Lunch and dinner"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Diet") {
                    LabeledContent("Type", value: profile.dietType.label)
                    Text("Favorites are prioritized. Recipes are matched to your diet type. Breakfast and dessert recipes are excluded.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Breakfast") {
                    LabeledContent("Include in planner") {
                        Text(settings.includeBreakfastInMealPrep ? "Enabled" : "Disabled")
                            .foregroundStyle(settings.includeBreakfastInMealPrep ? .primary : .secondary)
                    }
                    Text("Change this in Settings → Meal planner.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Schedule") {
                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                    Stepper("Days: \(numberOfDays)", value: $numberOfDays, in: 1...31)
                    Stepper("Servings per meal: \(servings)", value: $servings, in: 1...12)
                }

                Section {
                    Text("\(eligibleCount) recipes match this diet for meal planning.")
                        .foregroundStyle(.secondary)
                    Text("\(plannedSlotsDescription) will be planned for each day. Existing meals in this range will be replaced.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Plan your meals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Plan") { plan() }
                        .disabled(eligibleCount == 0)
                }
            }
            .onAppear {
                servings = settings.defaultPlannerServings
            }
        }
    }

    private func plan() {
        MealPlanner.planMeals(
            startingAt: startDate,
            numberOfDays: numberOfDays,
            servings: servings,
            dietType: profile.dietType,
            includeBreakfast: settings.includeBreakfastInMealPrep,
            recipes: recipes,
            existingMeals: scheduledMeals,
            context: modelContext
        )
        dismiss()
    }
}
