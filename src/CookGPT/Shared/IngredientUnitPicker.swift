//  IngredientUnitPicker.swift
//  CookGPT
//
//  Picker bound to default and custom units from settings.
//

import SwiftUI

struct IngredientUnitPicker: View {
    @Binding var unit: String
    var showsLabel: Bool = true
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        if showsLabel {
            Picker("Unit", selection: $unit) {
                unitOptions
            }
        } else {
            Picker("", selection: $unit) {
                unitOptions
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
    }

    @ViewBuilder
    private var unitOptions: some View {
        ForEach(settings.allUnits, id: \.self) { option in
            Text(option).tag(option)
        }
    }
}
