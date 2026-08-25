import SwiftUI
import SwiftData

struct GroceriesRootView: View {
    private enum Segment: String, CaseIterable {
        case shopping = "Shopping"
        case pantry = "Pantry"
    }

    @Query(sort: \GroceryList.name) private var groceryLists: [GroceryList]
    @Query(sort: \PantryItem.name) private var pantryItems: [PantryItem]
    @Environment(\.modelContext) private var modelContext

    @State private var segment: Segment = .shopping
    @State private var isAddingGrocery = false
    @State private var isAddingPantry = false

    private var primaryList: GroceryList? {
        groceryLists.first
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Section", selection: $segment) {
                ForEach(Segment.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            switch segment {
            case .shopping:
                shoppingContent
            case .pantry:
                pantryContent
            }
        }
        .navigationTitle("Groceries")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    switch segment {
                    case .shopping: isAddingGrocery = true
                    case .pantry: isAddingPantry = true
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingGrocery) {
            if let list = primaryList {
                AddGroceryItemSheet(list: list)
            }
        }
        .sheet(isPresented: $isAddingPantry) {
            AddPantryItemSheet()
        }
    }

    @ViewBuilder
    private var shoppingContent: some View {
        if let list = primaryList {
            List {
                ForEach(list.items, id: \.persistentModelID) { item in
                    GroceryItemRow(item: item)
                }
                .onDelete { offsets in
                    deleteGroceryItems(at: offsets, in: list)
                }
            }
        } else {
            EmptyStateView(
                systemImage: "cart",
                title: "No grocery list",
                subtitle: "A default list is created on first launch."
            )
        }
    }

    @ViewBuilder
    private var pantryContent: some View {
        if pantryItems.isEmpty {
            EmptyStateView(
                systemImage: "archivebox",
                title: "Pantry is empty",
                subtitle: "Add items to track what you have at home."
            )
        } else {
            List {
                ForEach(pantryItems) { item in
                    PantryItemRow(item: item)
                }
                .onDelete(perform: deletePantryItems)
            }
        }
    }

    private func deleteGroceryItems(at offsets: IndexSet, in list: GroceryList) {
        let items = list.items
        for index in offsets {
            modelContext.delete(items[index])
        }
        try? modelContext.save()
    }

    private func deletePantryItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(pantryItems[index])
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

private struct PantryItemRow: View {
    let item: PantryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
            Text("\(QuantityFormatter.string(item.quantity)) \(item.unit)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if let expiresOn = item.expiresOn {
                Text(expiresOn, format: .relative(presentation: .named))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        GroceriesRootView()
    }
    .modelContainer(try! CookGPTModelContainer.make())
}
