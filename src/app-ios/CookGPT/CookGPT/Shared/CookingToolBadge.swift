//  CookingToolBadge.swift
//  CookGPT
//
//  Icon capsule for recipe cooking tools.
//

import SwiftUI

struct CookingToolBadge: View {
    let tool: RecipeCookingTool

    var body: some View {
        Image(systemName: tool.systemImage)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.15))
            .foregroundStyle(.secondary)
            .clipShape(Capsule())
            .accessibilityLabel(tool.label)
    }
}

struct CookingToolOverflowBadge: View {
    let count: Int

    var body: some View {
        Text("+\(count)")
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.15))
            .foregroundStyle(.secondary)
            .clipShape(Capsule())
            .accessibilityLabel("\(count) more cooking tools")
    }
}

struct RecipeCookingToolsBadgeRow: View {
    let tools: [RecipeCookingTool]

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var visibleTools: [RecipeCookingTool] {
        guard overflowCount > 0 else { return tools }
        return Array(tools.prefix(visibleToolCount))
    }

    private var overflowCount: Int {
        if horizontalSizeClass == .compact {
            guard tools.count > 3 else { return 0 }
            return tools.count - 2
        }

        guard tools.count > 5 else { return 0 }
        return tools.count - 4
    }

    private var visibleToolCount: Int {
        if horizontalSizeClass == .compact {
            return overflowCount > 0 ? 2 : tools.count
        }
        return overflowCount > 0 ? 4 : tools.count
    }

    var body: some View {
        ForEach(visibleTools) { tool in
            CookingToolBadge(tool: tool)
        }

        if overflowCount > 0 {
            CookingToolOverflowBadge(count: overflowCount)
        }
    }
}
