//  IngredientUnitPicker.swift
//  CookGPT
//
//  Picker bound to measurement-system units from settings.
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
        ForEach(pickerUnits, id: \.self) { option in
            Text(option).tag(option)
        }
    }

    private var pickerUnits: [String] {
        var units = settings.availableUnits
        let trimmed = unit.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return units }
        guard !units.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) else { return units }
        units.append(trimmed)
        return units
    }
}
