import SwiftUI
import SwiftData

struct AddPantryItemSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var quantity = 1.0
    @State private var unit = "pcs"
    @State private var hasExpiry = false
    @State private var expiresOn = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Stepper("Quantity: \(QuantityFormatter.string(quantity))", value: $quantity, in: 0.1...100, step: 0.5)
                TextField("Unit", text: $unit)
                Toggle("Has expiry date", isOn: $hasExpiry)
                if hasExpiry {
                    DatePicker("Expires", selection: $expiresOn, displayedComponents: .date)
                }
            }
            .navigationTitle("Add to pantry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func save() {
        let item = PantryItem(
            name: name.trimmingCharacters(in: .whitespaces),
            quantity: quantity,
            unit: unit,
            expiresOn: hasExpiry ? expiresOn : nil
        )
        modelContext.insert(item)
        try? modelContext.save()
        dismiss()
    }
}
