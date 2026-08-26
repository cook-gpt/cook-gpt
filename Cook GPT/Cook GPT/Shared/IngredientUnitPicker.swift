import SwiftUI

struct IngredientUnitPicker: View {
    @Binding var unit: String
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        Picker("Unit", selection: $unit) {
            ForEach(settings.allUnits, id: \.self) { option in
                Text(option).tag(option)
            }
        }
    }
}
