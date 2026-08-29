//  GenerateShoppingListSheet.swift
//  CookGPT
//
//  Import groceries from schedule or selected recipes.
//

import SwiftUI
import SwiftData

enum GroceryImportOrigin: String, CaseIterable, Identifiable {
    case schedule
    case manual

    var id: String { rawValue }

    var label: String {
        switch self {
        case .schedule: "Schedule"
        case .manual: "Manual"
        }
    }
}

private struct ImportRow: Identifiable {
    let id = UUID()
    var kind: Kind

    var recipeID: UUID?
    var servings = 1

    var ingredientName = ""
    var ingredientQuantity = 1.0
    var ingredientUnit: String

    enum Kind {
        case recipe
        case ingredient
    }

    init(kind: Kind, ingredientUnit: String = "g") {
        self.kind = kind
        self.ingredientUnit = ingredientUnit
    }

    static func recipe() -> ImportRow {
        ImportRow(kind: .recipe)
    }

    static func ingredient(unit: String) -> ImportRow {
        ImportRow(kind: .ingredient, ingredientUnit: unit)
    }
}

struct GenerateShoppingListSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Query(sort: \ScheduledMeal.day) private var scheduledMeals: [ScheduledMeal]

    let list: GroceryList
    var onGenerated: () -> Void

    @State private var deletePreviousList = false
    @State private var importOrigin: GroceryImportOrigin = .manual
    @State private var scope: ShoppingListScope = .week
    @State private var customStart = Date()
    @State private var customEnd = Date()
    @State private var importRows: [ImportRow] = []
    @State private var recipePickerRowID: UUID?

    private var range: (start: Date, end: Date) {
        MealScheduleCalendar.dateRange(
            for: scope,
            referenceDate: .now,
            customStart: customStart,
            customEnd: customEnd
        )
    }

    private var mealsInRange: [ScheduledMeal] {
        let (start, end) = range
        return scheduledMeals.filter { meal in
            let day = MealScheduleCalendar.startOfDay(meal.day)
            return day >= start && day <= end
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Delete previous list", isOn: $deletePreviousList)
                } footer: {
                    Text("When off, imported ingredients are added to your existing list.")
                }

                Section {
                    Picker("Import from", selection: $importOrigin) {
                        ForEach(GroceryImportOrigin.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                } footer: {
                    switch importOrigin {
                    case .schedule:
                        Text("Import ingredients from meals scheduled in the selected range.")
                    case .manual:
                        Text("Pick recipes with servings or add individual ingredients.")
                    }
                }

                if importOrigin == .schedule {
                    scheduleRangeSection
                } else {
                    manualImportSection
                }
            }
            .navigationTitle("Import ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $recipePickerRowID) { rowID in
                RecipeImportPickerContent(
                    recipes: recipes,
                    excludedRecipeIDs: excludedRecipeIDs(except: rowID),
                    onSelect: { selectedRecipe in
                        guard let index = importRows.firstIndex(where: { $0.id == rowID }) else { return }
                        importRows[index].recipeID = selectedRecipe.id
                    }
                )
                .navigationTitle("Select recipe")
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { addToList() }
                        .disabled(!canAdd)
                }
            }
        }
    }

    @ViewBuilder
    private var scheduleRangeSection: some View {
        Section("Schedule range") {
            Picker("Range", selection: $scope) {
                ForEach(ShoppingListScope.allCases) { option in
                    Text(option.label).tag(option)
                }
            }

            if scope == .custom {
                DatePicker("From", selection: $customStart, displayedComponents: .date)
                DatePicker("To", selection: $customEnd, displayedComponents: .date)
            }

            Text("\(mealsInRange.count) scheduled meals in range")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var manualImportSection: some View {
        Section {
            ForEach($importRows) { $row in
                Group {
                    if row.kind == .recipe {
                        RecipeImportEntryRow(
                            recipeID: $row.recipeID,
                            servings: $row.servings,
                            recipes: recipes,
                            onOpenPicker: { recipePickerRowID = row.id }
                        )
                    } else {
                        GroceryImportIngredientRow(
                            name: $row.ingredientName,
                            quantity: $row.ingredientQuantity,
                            unit: $row.ingredientUnit
                        )
                    }
                }
                .id(row.id)
            }
            .onDelete(perform: deleteImportRows)

            importAddActionsRow
        } header: {
            Text("Groceries")
        } footer: {
            Text("Add recipes with servings, or add individual ingredients with amounts. Recipe ingredient amounts scale from each recipe's base serving size.")
        }
    }

    private var importAddActionsRow: some View {
        HStack(spacing: 0) {
            Button {
                importRows.append(ImportRow.recipe())
            } label: {
                Label("Add recipe", systemImage: "plus")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)

            Divider()
                .frame(height: 20)
                .padding(.horizontal, 12)

            Button {
                importRows.append(ImportRow.ingredient(unit: settings.defaultIngredientUnit))
            } label: {
                Label("Add ingredient", systemImage: "plus")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
        }
    }

    private var canAdd: Bool {
        switch importOrigin {
        case .schedule:
            return !mealsInRange.isEmpty
        case .manual:
            return hasValidRecipeImport || hasValidIngredientImport
        }
    }

    private var hasValidRecipeImport: Bool {
        importRows.contains { $0.kind == .recipe && $0.recipeID != nil }
    }

    private var hasValidIngredientImport: Bool {
        importRows.contains { row in
            guard row.kind == .ingredient else { return false }
            let name = row.ingredientName.trimmingCharacters(in: .whitespacesAndNewlines)
            return !name.isEmpty && row.ingredientQuantity > 0
        }
    }

    private func excludedRecipeIDs(except rowID: UUID) -> Set<UUID> {
        Set(
            importRows
                .filter { $0.id != rowID && $0.kind == .recipe }
                .compactMap(\.recipeID)
        )
    }

    private func deleteImportRows(at offsets: IndexSet) {
        importRows.remove(atOffsets: offsets)
    }

    private func addToList() {
        let recipeEntriesForImport: [(recipe: Recipe, servings: Int)]
        let sourceDescription: String
        let manualItems = importOrigin == .manual ? manualIngredientItems() : []

        switch importOrigin {
        case .schedule:
            recipeEntriesForImport = ShoppingListGenerator.recipes(from: mealsInRange)
            let (start, end) = range
            sourceDescription = ShoppingListGenerator.sourceLabel(for: scope, start: start, end: end)
        case .manual:
            recipeEntriesForImport = importRows.compactMap { row in
                guard row.kind == .recipe,
                      let recipeID = row.recipeID,
                      let recipe = recipes.first(where: { $0.id == recipeID }) else {
                    return nil
                }
                return (recipe: recipe, servings: row.servings)
            }
            sourceDescription = importSourceDescription(
                recipeCount: recipeEntriesForImport.count,
                ingredientCount: manualItems.count
            )
        }

        var imported = ShoppingListGenerator.aggregate(recipes: recipeEntriesForImport)
        if !manualItems.isEmpty {
            imported = mergeManualIngredients(manualItems, into: imported)
        }
        let finalItems: [AggregatedGroceryItem]

        if deletePreviousList {
            finalItems = imported
        } else {
            finalItems = ShoppingListGenerator.merge(aggregated: imported, with: list.items)
        }

        list.items.forEach { modelContext.delete($0) }
        list.items = []

        for item in finalItems {
            let groceryItem = GroceryItem(
                name: item.name,
                quantity: item.quantity,
                unit: item.unit,
                isChecked: item.isChecked,
                list: list
            )
            modelContext.insert(groceryItem)
            list.items.append(groceryItem)
        }

        if deletePreviousList || list.sourceDescription.isEmpty {
            list.sourceDescription = sourceDescription
        } else {
            list.sourceDescription = "\(list.sourceDescription) + \(sourceDescription)"
        }
        list.generatedAt = .now
        try? modelContext.save()
        onGenerated()
        dismiss()
    }

    private func manualIngredientItems() -> [AggregatedGroceryItem] {
        importRows.compactMap { row in
            guard row.kind == .ingredient else { return nil }
            let name = row.ingredientName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty, row.ingredientQuantity > 0 else { return nil }
            let unit = row.ingredientUnit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? settings.defaultIngredientUnit
                : row.ingredientUnit
            return AggregatedGroceryItem(
                id: "\(name)|\(unit)",
                name: name,
                unit: unit,
                quantity: row.ingredientQuantity
            )
        }
    }

    private func mergeManualIngredients(
        _ manualItems: [AggregatedGroceryItem],
        into imported: [AggregatedGroceryItem]
    ) -> [AggregatedGroceryItem] {
        var merged = imported
        for item in manualItems {
            if let index = merged.firstIndex(where: { $0.key == item.key }) {
                let existing = merged[index]
                merged[index] = AggregatedGroceryItem(
                    id: existing.id,
                    name: existing.name,
                    unit: existing.unit,
                    quantity: existing.quantity + item.quantity,
                    isChecked: existing.isChecked
                )
            } else {
                merged.append(item)
            }
        }
        return merged.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    private func importSourceDescription(recipeCount: Int, ingredientCount: Int) -> String {
        var parts: [String] = []
        if recipeCount > 0 {
            parts.append(ShoppingListGenerator.recipesLabel(count: recipeCount))
        }
        if ingredientCount > 0 {
            let label = ingredientCount == 1 ? "1 manual ingredient" : "\(ingredientCount) manual ingredients"
            parts.append(label)
        }
        return parts.joined(separator: ", ")
    }
}

private enum RecipeImportRowLayout {
    static let stepperWidth: CGFloat = 96
    static let chevronWidth: CGFloat = 12
    static let rowSpacing: CGFloat = 4
    static let columnSpacing: CGFloat = 8
}

private struct RecipeImportEntryRow: View {
    @Binding var recipeID: UUID?
    @Binding var servings: Int
    let recipes: [Recipe]
    let onOpenPicker: () -> Void

    private var recipe: Recipe? {
        guard let recipeID else { return nil }
        return recipes.first { $0.id == recipeID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: RecipeImportRowLayout.rowSpacing) {
            HStack(alignment: .center, spacing: RecipeImportRowLayout.columnSpacing) {
                Button(action: onOpenPicker) {
                    Text(recipe?.title ?? "Select recipe")
                        .foregroundStyle(recipe == nil ? .secondary : .primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .frame(width: RecipeImportRowLayout.chevronWidth)

                servingsStepper
            }

            if let recipe {
                HStack(alignment: .center, spacing: RecipeImportRowLayout.columnSpacing) {
                    Text("Ingredients: \(recipe.ingredients.count)")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Color.clear
                        .frame(width: RecipeImportRowLayout.chevronWidth)

                    Text("Servings: \(servings)")
                        .frame(width: RecipeImportRowLayout.stepperWidth, alignment: .trailing)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    private var servingsStepper: some View {
        Stepper("", value: $servings, in: 1...24)
            .labelsHidden()
            .disabled(recipe == nil)
            .frame(width: RecipeImportRowLayout.stepperWidth, alignment: .trailing)
    }
}

private struct GroceryImportIngredientRow: View {
    @Binding var name: String
    @Binding var quantity: Double
    @Binding var unit: String

    var body: some View {
        HStack(spacing: 8) {
            TextField("Ingredient", text: $name)
                .frame(maxWidth: .infinity)
                .layoutPriority(7)

            HStack(spacing: 6) {
                TextField("1", value: $quantity, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 44)

                IngredientUnitPicker(unit: $unit, showsLabel: false)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .frame(maxWidth: .infinity)
            .layoutPriority(3)
        }
    }
}

struct RecipeImportPickerContent: View {
    let recipes: [Recipe]
    let excludedRecipeIDs: Set<UUID>
    let onSelect: (Recipe) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var availableRecipes: [Recipe] {
        recipes.filter { !excludedRecipeIDs.contains($0.id) }
    }

    private var filteredRecipes: [Recipe] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return availableRecipes }
        return availableRecipes.filter { recipe in
            recipe.title.localizedCaseInsensitiveContains(query)
                || recipe.summary.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        List {
            if availableRecipes.isEmpty {
                ContentUnavailableView(
                    "No recipes left",
                    systemImage: "book.closed",
                    description: Text("All available recipes are already in your import list.")
                )
            } else if filteredRecipes.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                ForEach(filteredRecipes) { recipe in
                    Button {
                        onSelect(recipe)
                        dismiss()
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(recipe.title)
                            Text(recipePickerSubtitle(recipe))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search recipes")
    }

    private func recipePickerSubtitle(_ recipe: Recipe) -> String {
        let ingredientCount = recipe.ingredients.count
        let ingredientLabel = ingredientCount == 1 ? "1 ingredient" : "\(ingredientCount) ingredients"
        return "Serves \(recipe.servings) · \(ingredientLabel)"
    }
}
