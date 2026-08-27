//  DifficultyBadge.swift
//  Cook GPT
//
//  Colored capsule for recipe difficulty.
//

import SwiftUI

struct DifficultyBadge: View {
    let difficulty: RecipeDifficulty

    var body: some View {
        Text(difficulty.label)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor.opacity(0.2))
            .foregroundStyle(backgroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        switch difficulty {
        case .easy: .green
        case .medium: .orange
        case .hard: .red
        }
    }
}
