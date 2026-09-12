//  GroceriesRootView.swift
//  CookGPT
//
//  Groceries tab: checklist UI and import/add actions.
//

import SwiftUI
import SwiftData

struct GroceriesRootView: View {
    @Query(sort: \GroceryList.name) private var groceryLists: [GroceryList]
    @Query(sort: \Recipe.title) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings
    @Environment(AppNavigationStore.self) private var navigation

    @State private var isEditingGroceries = false
    @State private var ingredientDrafts: [GroceryIngredientDraft] = []
    @State private var recipeImportDrafts: [GroceryEditRecipeDraft] = []
    @State private var recipePickerContext: RecipePickerContext?
    @State private var showDeleteAllConfirmation = false

    private var primaryList: GroceryList? {
        groceryLists.first
    }

    private var exportableItems: [GroceryItem] {
        guard let list = primaryList else { return [] }
        return list.displayOrderedItems
    }

    private var exportShareText: String {
        guard let list = primaryList else { return "" }
        return GroceryListShareFormatter.text(listName: list.name, items: exportableItems)
    }

    private var listItems: [GroceryItem] {
        guard let list = primaryList else { return [] }
        if isEditingGroceries {
            return editModeItems(for: list)
        }
        return list.displayOrderedItems
    }

    private var completedCount: Int {
        listItems.filter(\.isChecked).count
    }

    private var totalCount: Int {
        listItems.count
    }

    private var completionProgress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    private var hasPersistedValidItems: Bool {
        guard let list = primaryList else { return false }
        return !editModeItems(for: list).isEmpty
    }

    private var hasRecipeImportDrafts: Bool {
        !recipeImportDrafts.isEmpty
    }

    private var hasValidEditRows: Bool {
        hasPersistedValidItems || hasFilledIngredientDrafts() || hasRecipeImportDrafts
    }

    private var canDeleteAllGroceries: Bool {
        hasValidEditRows || ingredientDrafts.count > 1
    }

    var body: some View {
        Group {
            if settings.isResettingData {
                ProgressView("Resetting app data…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if primaryList != nil {
                let list = primaryList!

                List {
                    if isEditingGroceries {
                        let items = editModeItems(for: list)

                        if !items.isEmpty {
                            Section {
                                ForEach(items, id: \.persistentModelID) { item in
                                    GroceryItemEditRow(item: item) {
                                        deleteItem(item)
                                    }
                                }
                            }
                        }

                        if !ingredientDrafts.isEmpty {
                            Section {
                                ForEach($ingredientDrafts) { $draft in
                                    GroceryIngredientDraftEditRow(
                                        draft: $draft,
                                        canDelete: canDeleteIngredientDraft(draft.id)
                                    ) {
                                        deleteIngredientDraft(draft.id)
                                    }
                                    .id(draft.id)
                                }
                            }
                        }

                        if !recipeImportDrafts.isEmpty {
                            Section {
                                ForEach($recipeImportDrafts) { $draft in
                                    GroceryRecipeEditRow(
                                        recipeID: $draft.recipeID,
                                        servings: $draft.servings,
                                        recipes: recipes,
                                        onOpenPicker: { recipePickerContext = RecipePickerContext(id: draft.id) },
                                        onDelete: { deleteRecipeDraft(draft.id) }
                                    )
                                    .id(draft.id)
                                }
                            }
                        }

                        Section {
                            editAddActionsRow
                        }
                    } else {
                        let checkedItems = checkedItems(for: list)
                        let uncheckedItems = uncheckedItems(for: list)

                        if checkedItems.isEmpty && uncheckedItems.isEmpty {
                            ContentUnavailableView(
                                "No items yet",
                                systemImage: "cart",
                                description: Text("Tap the edit button to add recipes and ingredients.")
                            )
                        } else {
                            if !checkedItems.isEmpty {
                                Section {
                                    ForEach(checkedItems, id: \.persistentModelID) { item in
                                        GroceryItemRow(
                                            item: item,
                                            animationOrder: highlightAnimationOrder(
                                                for: item,
                                                in: checkedItems + uncheckedItems
                                            ),
                                            onToggleCheck: { toggleItemCheck(item) },
                                            onDelete: { deleteItem(item) }
                                        )
                                    }
                                    .onMove { source, destination in
                                        moveItems(from: source, to: destination, in: checkedItems)
                                    }
                                }
                            }

                            if !uncheckedItems.isEmpty {
                                Section {
                                    ForEach(uncheckedItems, id: \.persistentModelID) { item in
                                        GroceryItemRow(
                                            item: item,
                                            animationOrder: highlightAnimationOrder(
                                                for: item,
                                                in: checkedItems + uncheckedItems
                                            ),
                                            onToggleCheck: { toggleItemCheck(item) },
                                            onDelete: { deleteItem(item) }
                                        )
                                    }
                                    .onMove { source, destination in
                                        moveItems(from: source, to: destination, in: uncheckedItems)
                                    }
                                }
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(isEditingGroceries ? .inactive : .active))
                .listSectionSpacing(8)
            } else {
                EmptyStateView(
                    systemImage: "cart",
                    title: "No shopping list",
                    subtitle: "A default list is created on first launch."
                )
            }
        }
        .navigationTitle(groceriesNavigationBarTitle)
        .sheet(item: $recipePickerContext) { context in
            NavigationStack {
                RecipeImportPickerContent(
                    recipes: recipes,
                    excludedRecipeIDs: excludedRecipeIDs(except: context.id),
                    onSelect: { selectedRecipe in
                        guard let index = recipeImportDrafts.firstIndex(where: { $0.id == context.id }) else { return }
                        recipeImportDrafts[index].recipeID = selectedRecipe.id
                        recipePickerContext = nil
                    }
                )
                .navigationTitle("Select recipe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            recipePickerContext = nil
                        }
                    }
                }
            }
        }
        .toolbarTitleDisplayMode(.automatic)
        .toolbarVisibility(.visible, for: .automatic)
        .toolbar {
            if totalCount > 0 {
                ToolbarItem(placement: .largeTitle) {
                    groceriesLargeTitle
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                if isEditingGroceries {
                    Button {
                        showDeleteAllConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(canDeleteAllGroceries ? .red : .secondary)
                    }
                    .disabled(!canDeleteAllGroceries)
                    .accessibilityLabel("Delete all groceries")
                } else {
                    ShareLink(
                        item: exportShareText,
                        subject: Text(primaryList?.name ?? "Grocery list")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(primaryList == nil || exportableItems.isEmpty)
                    .accessibilityLabel("Export grocery list")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                if primaryList != nil {
                    Button {
                        if isEditingGroceries {
                            finishEditingGroceries()
                        } else {
                            beginEditingGroceries()
                        }
                    } label: {
                        if isEditingGroceries {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName: "pencil")
                        }
                    }
                    .accessibilityLabel(isEditingGroceries ? "Done editing" : "Edit groceries")
                }
            }
        }
        .onChange(of: navigation.highlightedGroceryItemKeys) { _, keys in
            scheduleHighlightClearance(for: keys)
        }
        .alert("Delete all groceries?", isPresented: $showDeleteAllConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete all", role: .destructive) {
                deleteAllGroceries()
            }
        } message: {
            Text("This will remove every item from your grocery list.")
        }
    }

    private var groceriesNavigationBarTitle: String {
        guard totalCount > 0 else { return "Groceries" }
        return "Groceries  \(completedCount)/\(totalCount)"
    }

    private var groceriesLargeTitle: some View {
        HStack(spacing: 10) {
            Text("Groceries")
                .font(.largeTitle.bold())

            GroceryCompletionRing(
                progress: completionProgress,
                diameter: 24,
                lineWidth: 3
            )
            .accessibilityLabel("Shopping progress")
            .accessibilityValue("\(completedCount) of \(totalCount) completed")

            groceriesCompletionCounter(font: .title3.weight(.semibold))
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func groceriesCompletionCounter(font: Font) -> some View {
        Text("\(completedCount)/\(totalCount)")
            .font(font)
            .monospacedDigit()
            .foregroundStyle(.secondary)
            .accessibilityLabel("Shopping progress")
            .accessibilityValue("\(completedCount) of \(totalCount) completed")
    }

    private func highlightAnimationOrder(for item: GroceryItem, in items: [GroceryItem]) -> Int? {
        let keys = navigation.highlightedGroceryItemKeys
        guard keys.contains(item.mergeKey) else { return nil }

        let highlightedItems = items.filter { keys.contains($0.mergeKey) }
        return highlightedItems.firstIndex(where: { $0.persistentModelID == item.persistentModelID })
    }

    private func scheduleHighlightClearance(for keys: Set<String>) {
        guard !keys.isEmpty else { return }

        let staggerDuration = 0.08
        let animationDuration = 0.9
        let totalDuration = animationDuration + Double(keys.count) * staggerDuration

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(totalDuration))
            guard navigation.highlightedGroceryItemKeys == keys else { return }
            navigation.clearGroceryHighlights()
        }
    }

    private func checkedItems(for list: GroceryList) -> [GroceryItem] {
        list.items.filter { $0.isChecked && $0.hasContent }.sorted { $0.sortOrder < $1.sortOrder }
    }

    private func uncheckedItems(for list: GroceryList) -> [GroceryItem] {
        list.items.filter { !$0.isChecked && $0.hasContent }.sorted { $0.sortOrder < $1.sortOrder }
    }

    private func editModeItems(for list: GroceryList) -> [GroceryItem] {
        list.items
            .filter(\.hasContent)
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    private var editAddActionsRow: some View {
        HStack(spacing: 0) {
            Button(action: addRecipeDraft) {
                Label("Add recipe", systemImage: "plus")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)

            Divider()
                .frame(height: 20)
                .padding(.horizontal, 12)

            Button(action: addIngredient) {
                Label("Add ingredient", systemImage: "plus")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
        }
    }

    private func addRecipeDraft() {
        recipeImportDrafts.append(GroceryEditRecipeDraft())
    }

    private func deleteRecipeDraft(_ id: UUID) {
        recipeImportDrafts.removeAll { $0.id == id }
        ensureMinimumEditPlaceholderRow()
    }

    private func excludedRecipeIDs(except draftID: UUID) -> Set<UUID> {
        Set(
            recipeImportDrafts
                .filter { $0.id != draftID }
                .compactMap(\.recipeID)
        )
    }

    private func beginEditingGroceries() {
        recipeImportDrafts = []
        ingredientDrafts = []

        if let list = primaryList {
            purgeEmptyPersistedItems(from: list)
            if editModeItems(for: list).isEmpty {
                addIngredientDraft()
            }
        }

        isEditingGroceries = true
    }

    private func purgeEmptyPersistedItems(from list: GroceryList) {
        let emptyItems = list.items.filter { !$0.hasContent }
        guard !emptyItems.isEmpty else { return }

        for item in emptyItems {
            modelContext.delete(item)
        }
        list.items.removeAll { item in
            emptyItems.contains { $0.persistentModelID == item.persistentModelID }
        }
        try? modelContext.save()
    }

    private func addIngredientDraft() {
        ingredientDrafts.append(
            GroceryIngredientDraft(unit: settings.defaultIngredientUnit)
        )
    }

    private func deleteIngredientDraft(_ id: UUID) {
        guard canDeleteIngredientDraft(id) else { return }
        ingredientDrafts.removeAll { $0.id == id }
        ensureMinimumEditPlaceholderRow()
    }

    private func canDeleteIngredientDraft(_ id: UUID) -> Bool {
        guard let draft = ingredientDrafts.first(where: { $0.id == id }) else { return false }
        guard draft.trimmedName.isEmpty else { return true }

        if hasPersistedValidItems || hasRecipeImportDrafts || hasFilledIngredientDrafts(excluding: id) {
            return true
        }

        return ingredientDrafts.count > 1
    }

    private func hasFilledIngredientDrafts(excluding excludedID: UUID? = nil) -> Bool {
        ingredientDrafts.contains { draft in
            draft.id != excludedID && !draft.trimmedName.isEmpty
        }
    }

    private func ensureMinimumEditPlaceholderRow() {
        guard isEditingGroceries else { return }
        guard !hasPersistedValidItems, !hasRecipeImportDrafts, !hasFilledIngredientDrafts() else { return }
        guard ingredientDrafts.isEmpty else { return }
        addIngredientDraft()
    }

    private func addIngredient() {
        addIngredientDraft()
    }

    private func deleteItem(_ item: GroceryItem) {
        modelContext.delete(item)
        try? modelContext.save()
        ensureMinimumEditPlaceholderRow()
    }

    private func deleteAllGroceries() {
        guard let list = primaryList else { return }

        list.items.forEach { modelContext.delete($0) }
        list.items = []
        recipeImportDrafts = []
        ingredientDrafts = [
            GroceryIngredientDraft(unit: settings.defaultIngredientUnit),
        ]
        try? modelContext.save()
    }

    private func finishEditingGroceries() {
        guard let list = primaryList else {
            isEditingGroceries = false
            return
        }

        for item in list.items {
            item.name = item.trimmedName
            if item.quantity <= 0 {
                item.quantity = 1
            }
            let trimmedUnit = item.unit.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedUnit.isEmpty {
                item.unit = settings.defaultIngredientUnit
            }
        }

        purgeEmptyPersistedItems(from: list)

        let draftItems = ingredientDrafts.compactMap(aggregatedIngredientDraft)
        let recipeEntries = recipeImportDrafts.compactMap { draft -> (recipe: Recipe, servings: Int)? in
            guard let recipeID = draft.recipeID,
                  let recipe = recipes.first(where: { $0.id == recipeID }) else {
                return nil
            }
            return (recipe: recipe, servings: draft.servings)
        }

        let imported = ShoppingListGenerator.aggregate(recipes: recipeEntries) + draftItems
        let merged = ShoppingListGenerator.merge(aggregated: imported, with: list.items)
        applyMergedItems(merged, to: list)

        ingredientDrafts = []
        recipeImportDrafts = []
        try? modelContext.save()
        isEditingGroceries = false
    }

    private func aggregatedIngredientDraft(_ draft: GroceryIngredientDraft) -> AggregatedGroceryItem? {
        let name = draft.trimmedName
        guard !name.isEmpty else { return nil }

        let unit = draft.unit.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? settings.defaultIngredientUnit
            : draft.unit
        let quantity = draft.quantity > 0 ? draft.quantity : 1

        return AggregatedGroceryItem(
            id: "\(name)|\(unit)",
            name: name,
            unit: unit,
            quantity: quantity
        )
    }

    private func applyMergedItems(_ merged: [AggregatedGroceryItem], to list: GroceryList) {
        list.items.forEach { modelContext.delete($0) }
        list.items = []

        for (index, item) in merged.enumerated() {
            let groceryItem = GroceryItem(
                name: item.name,
                quantity: item.quantity,
                unit: item.unit,
                isChecked: item.isChecked,
                sortOrder: index,
                list: list
            )
            modelContext.insert(groceryItem)
            list.items.append(groceryItem)
        }

        list.normalizePartitionedSortOrders()
    }

    private func toggleItemCheck(_ item: GroceryItem) {
        guard let list = primaryList else { return }

        if item.isChecked {
            item.isChecked = false
            item.sortOrder = list.nextSortOrder(isChecked: false, excluding: item)
            try? modelContext.save()
            return
        }

        if let match = list.items.first(where: {
            $0.persistentModelID != item.persistentModelID
                && $0.isChecked
                && $0.mergeKey == item.mergeKey
        }) {
            match.quantity += item.quantity
            modelContext.delete(item)
        } else {
            item.isChecked = true
            item.sortOrder = list.nextSortOrder(isChecked: true, excluding: item)
        }

        try? modelContext.save()
    }

    private func moveItems(from source: IndexSet, to destination: Int, in items: [GroceryItem]) {
        var reordered = items
        reordered.move(fromOffsets: source, toOffset: destination)

        for (index, item) in reordered.enumerated() {
            item.sortOrder = index
        }

        try? modelContext.save()
    }
}

private struct GroceryCompletionRing: View {
    let progress: Double
    var diameter: CGFloat = 18
    var lineWidth: CGFloat = 2.5

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.25), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(Color.green, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: diameter, height: diameter)
        .animation(.easeInOut(duration: 0.3), value: progress)
    }
}

private struct RecipePickerContext: Identifiable {
    let id: UUID
}

private struct GroceryIngredientDraft: Identifiable {
    let id = UUID()
    var name = ""
    var quantity = 1.0
    var unit = ""

    init(unit: String = "") {
        self.unit = unit
    }

    var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct GroceryEditRecipeDraft: Identifiable {
    let id = UUID()
    var recipeID: UUID?
    var servings = 1
}

private struct GroceryIngredientDraftEditRow: View {
    @Binding var draft: GroceryIngredientDraft
    let canDelete: Bool
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(canDelete ? .red : .secondary)
            }
            .buttonStyle(.plain)
            .disabled(!canDelete)
            .accessibilityLabel("Remove ingredient")

            EditableIngredientRow(
                name: $draft.name,
                quantity: $draft.quantity,
                unit: $draft.unit
            )
        }
        .padding(.vertical, 2)
    }
}

private struct GroceryRecipeEditRow: View {
    @Binding var recipeID: UUID?
    @Binding var servings: Int
    let recipes: [Recipe]
    let onOpenPicker: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove recipe import")

            RecipeImportEntryRow(
                recipeID: $recipeID,
                servings: $servings,
                recipes: recipes,
                onOpenPicker: onOpenPicker
            )
        }
        .padding(.vertical, 2)
    }
}

private struct GroceryItemEditRow: View {
    @Bindable var item: GroceryItem
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete \(item.name)")

            EditableIngredientRow(
                name: $item.name,
                quantity: $item.quantity,
                unit: $item.unit
            )
        }
        .padding(.vertical, 2)
    }
}

private struct GroceryItemRow: View {
    @Bindable var item: GroceryItem
    let animationOrder: Int?
    let onToggleCheck: () -> Void
    let onDelete: () -> Void

    @Environment(AppNavigationStore.self) private var navigation
    @State private var highlightAmount: CGFloat = 0

    private var isHighlighted: Bool {
        navigation.highlightedGroceryItemKeys.contains(item.mergeKey)
    }

    var body: some View {
        Button(action: onToggleCheck) {
            HStack {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isChecked ? .green : .secondary)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .strikethrough(item.isChecked)
                    Text("\(QuantityFormatter.string(item.quantity)) \(item.unit)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.blue.opacity(0.16 * highlightAmount))
            )
            .scaleEffect(1 + (0.03 * highlightAmount))
            .offset(x: 10 * (1 - highlightAmount))
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
        .onAppear {
            animateHighlightIfNeeded()
        }
        .onChange(of: navigation.highlightedGroceryItemKeys) { _, _ in
            animateHighlightIfNeeded()
        }
    }

    private func animateHighlightIfNeeded() {
        guard isHighlighted, highlightAmount == 0 else { return }

        let delay = Double(animationOrder ?? 0) * 0.08

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(delay))
            guard isHighlighted else { return }

            withAnimation(.spring(response: 0.34, dampingFraction: 0.72)) {
                highlightAmount = 1
            }

            try? await Task.sleep(for: .milliseconds(420))

            withAnimation(.easeOut(duration: 0.45)) {
                highlightAmount = 0
            }
        }
    }
}

#Preview {
    NavigationStack {
        GroceriesRootView()
    }
    .environment(AppNavigationStore.shared)
    .modelContainer(try! CookGPTModelContainer.make())
}
