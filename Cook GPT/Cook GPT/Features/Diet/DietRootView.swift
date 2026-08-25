import SwiftUI
import SwiftData

struct DietRootView: View {
    @Query(filter: #Predicate<DietProfile> { $0.isActive == true })
    private var activeProfiles: [DietProfile]

    @Query(sort: \MealLogEntry.date, order: .reverse)
    private var mealEntries: [MealLogEntry]

    @State private var isLoggingMeal = false

    private var activeProfile: DietProfile? {
        activeProfiles.first
    }

    private var todaysEntries: [MealLogEntry] {
        mealEntries.filter { Calendar.current.isDateInToday($0.date) }
    }

    private var todaysCalories: Int {
        todaysEntries.reduce(0) { $0 + $1.calories }
    }

    var body: some View {
        Group {
            if let profile = activeProfile {
                List {
                    Section("Active profile") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(profile.name)
                                .font(.title2.bold())
                            Text("Daily goal: \(profile.dailyCalorieGoal) kcal")
                                .foregroundStyle(.secondary)
                            HStack {
                                macroChip("Protein", grams: profile.proteinGrams)
                                macroChip("Carbs", grams: profile.carbGrams)
                                macroChip("Fat", grams: profile.fatGrams)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section("Today's progress") {
                        ProgressView(
                            value: Double(todaysCalories),
                            total: Double(max(profile.dailyCalorieGoal, 1))
                        )
                        Text("\(todaysCalories) / \(profile.dailyCalorieGoal) kcal logged")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Section("Today's meals") {
                        if todaysEntries.isEmpty {
                            Text("No meals logged yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(todaysEntries) { entry in
                                MealLogRowView(entry: entry)
                            }
                        }
                    }
                }
            } else {
                EmptyStateView(
                    systemImage: "heart.text.square",
                    title: "No diet profile",
                    subtitle: "An active diet profile will appear after seeding."
                )
            }
        }
        .navigationTitle("Diet")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isLoggingMeal = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(activeProfile == nil)
            }
        }
        .sheet(isPresented: $isLoggingMeal) {
            LogMealSheet()
        }
    }

    private func macroChip(_ label: String, grams: Int) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("\(grams)g")
                .font(.caption.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct MealLogRowView: View {
    let entry: MealLogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.mealType.label)
                    .font(.headline)
                Spacer()
                Text("\(entry.calories) kcal")
                    .foregroundStyle(.secondary)
            }
            if let recipe = entry.recipe {
                Text(recipe.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else if !entry.note.isEmpty {
                Text(entry.note)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        DietRootView()
    }
    .modelContainer(try! CookGPTModelContainer.make())
}
