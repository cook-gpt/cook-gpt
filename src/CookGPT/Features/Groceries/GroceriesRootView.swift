//  GroceriesRootView.swift
//  CookGPT
//
//  Groceries tab: checklist UI and import/add actions.
//

import SwiftUI
import SwiftData

struct GroceriesRootView: View {
    @Query(sort: \GroceryList.name) private var groceryLists: [GroceryList]
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    @State private var isImportingIngredients = false

    private var primaryList: GroceryList? {
        groceryLists.first
    }

    private var exportableItems: [GroceryItem] {
        guard let list = primaryList else { return [] }
        return sortedItems(for: list)
    }

    private var exportShareText: String {
        guard let list = primaryList else { return "" }
        return GroceryListShareFormatter.text(listName: list.name, items: exportableItems)
    }

    var body: some View {
        Group {
            if settings.isResettingData {
                ProgressView("Resetting app data…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let list = primaryList {
                let items = sortedItems(for: list)
                let remaining = items.filter { !$0.isChecked }.count
                let total = items.count

                List {
                    if total > 0 {
                        Section {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("\(remaining)/\(total)")
                                    .font(.title2.bold().monospacedDigit())
                                Text("left")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    if items.isEmpty {
                        ContentUnavailableView(
                            "No items yet",
                            systemImage: "cart",
                            description: Text("Tap + to import groceries from recipes, ingredients, or your meal schedule.")
                        )
                    } else {
                        ForEach(items, id: \.persistentModelID) { item in
                            GroceryItemRow(item: item)
                        }
                        .onDelete { offsets in
                            deleteItems(at: offsets, in: items)
                        }
                    }
                }
            } else {
                EmptyStateView(
                    systemImage: "cart",
                    title: "No shopping list",
                    subtitle: "A default list is created on first launch."
                )
            }
        }
        .navigationTitle("Groceries")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                ShareLink(
                    item: exportShareText,
                    subject: Text(primaryList?.name ?? "Grocery list")
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(primaryList == nil || exportableItems.isEmpty)
                .accessibilityLabel("Export grocery list")
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isImportingIngredients = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(primaryList == nil)
            }
        }
        .sheet(isPresented: $isImportingIngredients) {
            if let list = primaryList {
                GenerateShoppingListSheet(list: list) {}
            }
        }
    }

    private func sortedItems(for list: GroceryList) -> [GroceryItem] {
        list.items.sorted { lhs, rhs in
            if lhs.isChecked != rhs.isChecked {
                return lhs.isChecked && !rhs.isChecked
            }
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }

    private func deleteItems(at offsets: IndexSet, in items: [GroceryItem]) {
        for index in offsets {
            modelContext.delete(items[index])
        }
        try? modelContext.save()
    }
}

private struct GroceryItemRow: View {
    @Bindable var item: GroceryItem

    var body: some View {
        Button {
            item.isChecked.toggle()
        } label: {
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
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        GroceriesRootView()
    }
    .modelContainer(try! CookGPTModelContainer.make())
}
