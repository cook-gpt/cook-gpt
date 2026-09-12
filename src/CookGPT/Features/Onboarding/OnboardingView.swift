//  OnboardingView.swift
//  CookGPT
//
//  First-launch tutorial: app overview, starter recipe packs, and notifications.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppSettingsStore.self) private var settings

    let isReplay: Bool
    let onDismiss: () -> Void

    @State private var step = 0
    @State private var selectedPackIDs: Set<String> = []

    private let totalSteps = 3
    private let recipePackColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.42)
                    .ignoresSafeArea()

                onboardingCard(recipePackScrollHeight: recipePackScrollHeight(for: geometry.size.height))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            if isReplay {
                selectedPackIDs = Set(settings.allCategories.map(\.id))
            }
        }
    }

    private func recipePackScrollHeight(for screenHeight: CGFloat) -> CGFloat {
        min(max(screenHeight * 0.36, 300), 380)
    }

    private func onboardingCard(recipePackScrollHeight: CGFloat) -> some View {
        VStack(spacing: 0) {
            stepIndicator
                .padding(.top, 20)
                .padding(.bottom, 12)

            Group {
                switch step {
                case 0:
                    welcomeStep
                case 1:
                    recipePacksStep(scrollHeight: recipePackScrollHeight)
                default:
                    notificationsStep
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(.horizontal, 20)

            actionBar
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: 420)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.12))
        }
        .padding(24)
        .shadow(color: .black.opacity(0.18), radius: 24, y: 12)
    }

    private var stepIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index == step ? Color.accentColor : Color.secondary.opacity(0.25))
                    .frame(width: index == step ? 22 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: step)
            }
        }
        .accessibilityLabel("Step \(step + 1) of \(totalSteps)")
    }

    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Welcome to CookGPT")
                .font(.title2.weight(.semibold))

            Text("Plan meals, cook with step timers, and shop smarter — all on your device.")
                .foregroundStyle(.secondary)

            VStack(spacing: 12) {
                onboardingFeatureRow(
                    systemImage: "book.closed",
                    title: "Recipes",
                    subtitle: "Browse, favorite, and filter recipes by category."
                )
                onboardingFeatureRow(
                    systemImage: "calendar",
                    title: "Meals",
                    subtitle: "Schedule lunch and dinner by day, week, or month."
                )
                onboardingFeatureRow(
                    systemImage: "cart",
                    title: "Groceries",
                    subtitle: "Build a shopping list from your meal plan."
                )
            }
        }
    }

    private func recipePacksStep(scrollHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Choose starter recipes")
                .font(.title2.weight(.semibold))

            Text(isReplay
                ? "These packs match the categories currently in your library."
                : "Pick the collections you want. We only add categories and recipes you select.")
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ScrollView {
                LazyVGrid(columns: recipePackColumns, spacing: 12) {
                    ForEach(RecipePackCatalog.packs) { pack in
                        recipePackTile(pack)
                    }
                }
                .padding(.vertical, 2)
            }
            .frame(height: scrollHeight)
        }
    }

    private var notificationsStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Timer alerts")
                .font(.title2.weight(.semibold))

            Text("CookGPT can notify you when a step timer finishes, even if the app is in the background.")
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                Label("Lock Screen and Dynamic Island timers", systemImage: "timer")
                Label("Clock-style alarm sounds on device", systemImage: "bell")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Button {
                Task {
                    await TimerCompletionNotifier.requestAuthorizationIfNeeded()
                    finishOnboarding()
                }
            } label: {
                Label("Enable notifications", systemImage: "bell.badge")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            Button("Skip", action: finishOnboarding)
                .foregroundStyle(.secondary)

            Spacer()

            if step < totalSteps - 1 {
                Button("Next") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        step += 1
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Get started", action: finishOnboarding)
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    @ViewBuilder
    private func onboardingFeatureRow(systemImage: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.quaternary.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    @ViewBuilder
    private func recipePackTile(_ pack: RecipePackDefinition) -> some View {
        let isSelected = selectedPackIDs.contains(pack.categoryID)

        Button {
            guard !isReplay else { return }
            if isSelected {
                selectedPackIDs.remove(pack.categoryID)
            } else {
                selectedPackIDs.insert(pack.categoryID)
            }
        } label: {
            VStack(spacing: 10) {
                Spacer(minLength: 0)

                Image(systemName: pack.systemImage)
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(isSelected ? Color.accentColor : .secondary)
                    .symbolRenderingMode(.hierarchical)

                Spacer(minLength: 0)

                Text(pack.localizedLabel)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(isSelected ? Color.accentColor.opacity(0.14) : Color.clear)
            .background(.quaternary.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        isSelected ? Color.accentColor : Color.primary.opacity(0.08),
                        lineWidth: isSelected ? 2 : 1
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isReplay)
        .accessibilityLabel(pack.localizedLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func finishOnboarding() {
        if !isReplay {
            SampleDataSeeder.seedSelectedPacks(
                categoryIDs: Array(selectedPackIDs),
                context: modelContext,
                settings: settings
            )
            settings.markOnboardingCompleted()
        }

        settings.dismissOnboardingPresentation()
        onDismiss()
    }
}
