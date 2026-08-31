//  RecipeCookingToolsSection.swift
//  CookGPT
//
//  Cooking tool toggles for the recipe editor.
//

import SwiftUI

struct RecipeCookingToolsSection: View {
    @Binding var selectedCookingTools: Set<RecipeCookingTool>

    var body: some View {
        Section {
            ForEach(RecipeCookingTool.allCases) { tool in
                Toggle(isOn: binding(for: tool)) {
                    Label(tool.label, systemImage: tool.systemImage)
                }
            }
        } header: {
            Text("Cooking tools")
        } footer: {
            Text("Selected tools appear on the recipe list next to difficulty.")
        }
    }

    private func binding(for tool: RecipeCookingTool) -> Binding<Bool> {
        Binding(
            get: { selectedCookingTools.contains(tool) },
            set: { isSelected in
                if isSelected {
                    selectedCookingTools.insert(tool)
                } else {
                    selectedCookingTools.remove(tool)
                }
            }
        )
    }
}
