//  EditableIngredientRow.swift
//  CookGPT
//
//  Inline ingredient name, quantity, and unit fields.
//

import SwiftUI

struct EditableIngredientRow: View {
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
