//  AddGroceryItemSheet.swift
//  Cook GPT
//
//  Manually add one item to the shopping list.
//

import SwiftUI
import SwiftData

struct AddGroceryItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    let list: GroceryList

    @State private var name = ""
    @State private var quantity = 1.0
    @State private var unit = "g"

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Quantity", value: $quantity, format: .number)
                    .keyboardType(.decimalPad)
                IngredientUnitPicker(unit: $unit)
            }
            .navigationTitle("Add item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || quantity <= 0)
                }
            }
            .onAppear {
                unit = settings.allUnits.first ?? "g"
            }
        }
    }

    private func save() {
        guard quantity > 0 else { return }

        let item = GroceryItem(
            name: name.trimmingCharacters(in: .whitespaces),
            quantity: quantity,
            unit: unit,
            list: list
        )
        modelContext.insert(item)
        list.items.append(item)
        try? modelContext.save()
        dismiss()
    }
}
