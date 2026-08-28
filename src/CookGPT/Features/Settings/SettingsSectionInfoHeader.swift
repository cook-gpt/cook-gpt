//  SettingsSectionInfoHeader.swift
//  CookGPT
//
//  Info control and section headers for Settings reference text.
//

import SwiftUI

struct SettingsInfoButton: View {
    let detail: String
    var accessibilityLabel: String = "More information"

    @State private var isPresented = false
    @State private var dismissTask: Task<Void, Never>?
    @State private var isHovering = false

    var body: some View {
        Button {
            presentDetail()
        } label: {
            Image(systemName: "info.circle")
                .imageScale(.small)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .popover(isPresented: $isPresented) {
            Text(detail)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 280, alignment: .leading)
                .padding()
                .presentationCompactAdaptation(.popover)
        }
        .onHover { hovering in
            isHovering = hovering
            if hovering {
                presentDetail()
            } else {
                scheduleDismiss()
            }
        }
    }

    private func presentDetail() {
        dismissTask?.cancel()
        isPresented = true
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(2.5))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if !isHovering {
                    isPresented = false
                }
            }
        }
    }

    private func scheduleDismiss() {
        dismissTask?.cancel()
        dismissTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                isPresented = false
            }
        }
    }
}

struct SettingsSectionInfoHeader: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
            SettingsInfoButton(detail: detail, accessibilityLabel: "\(title) information")
        }
    }
}
