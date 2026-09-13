//  EmptyStateView.swift
//  CookGPT
//
//  Reusable empty-state placeholder.
//

import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    var body: some View {
        ContentUnavailableView(title, systemImage: systemImage, description: Text(subtitle))
    }
}
