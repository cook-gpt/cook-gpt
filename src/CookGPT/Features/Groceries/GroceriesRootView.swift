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

    @State private var generateSource: GenerateShoppingListSource?
    @State private var isAddingItem = false

    private var primaryList: GroceryList? {
        groceryLists.first
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
                            description: Text("Generate a list from scheduled meals or selected recipes.")
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
                Menu {
                    Button("From schedule") {
                        generateSource = .schedule
                    }
                    Button("From recipe") {
                        generateSource = .recipe
                    }
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .disabled(primaryList == nil)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isAddingItem = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(primaryList == nil)
            }
        }
        .sheet(item: $generateSource) { source in
            if let list = primaryList {
                GenerateShoppingListSheet(list: list, source: source) {}
            }
        }
        .sheet(isPresented: $isAddingItem) {
            if let list = primaryList {
                AddGroceryItemSheet(list: list)
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
