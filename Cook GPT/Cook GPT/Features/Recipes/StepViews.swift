import SwiftUI

struct RecipeStepRowView: View {
    let step: RecipeStep
    let stepNumber: Int
    let recipe: Recipe
    var cookingSession: CookingSessionManager

    @Environment(\.colorScheme) private var colorScheme

    private var isTimerLive: Bool {
        cookingSession.timerStore.isLive(stepID: step.id)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in
            let timer = cookingSession.timerStore.timer(for: step.id)

            if let timer, timer.isFinished {
                Color.clear
                    .frame(height: 0)
                    .onAppear {
                        cookingSession.timerStore.complete(stepID: step.id)
                    }
            }

            rowContent(timer: timer)
        }
        .modifier(LiveTimerRowBackground(isLive: isTimerLive, colorScheme: colorScheme))
    }

    @ViewBuilder
    private func rowContent(timer: CookingTimerStore.RunningTimer?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Step \(stepNumber)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(step.instruction)
                .font(.body)

            stepControls(timer: timer)
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private func stepControls(timer: CookingTimerStore.RunningTimer?) -> some View {
        if let timer {
            timerControlBar(timer: timer)
        } else if let duration = step.timerSeconds {
            Button {
                cookingSession.timerStore.start(
                    stepID: step.id,
                    recipeID: recipe.id,
                    recipeTitle: recipe.title,
                    label: step.displayLabel,
                    duration: duration
                )
            } label: {
                Label("Start \(TimerFormatting.string(seconds: duration))", systemImage: "timer")
                    .font(.subheadline)
            }
            .buttonStyle(.borderless)
            .padding(.top, 4)
        }
    }

    @ViewBuilder
    private func timerControlBar(timer: CookingTimerStore.RunningTimer) -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: timer.phase == .paused ? "pause.circle.fill" : "timer")
                    .foregroundStyle(.orange)
                Text(TimerFormatting.string(seconds: timer.displayRemaining))
                    .font(.subheadline.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.orange)
                if timer.phase == .paused {
                    Text("Paused")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)

            if timer.phase == .running {
                Button {
                    cookingSession.timerStore.pause(stepID: step.id)
                } label: {
                    Image(systemName: "pause.fill")
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Pause timer")
            } else {
                Button {
                    cookingSession.timerStore.resume(stepID: step.id)
                } label: {
                    Image(systemName: "play.fill")
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Resume timer")
            }

            Button(role: .destructive) {
                cookingSession.timerStore.stop(stepID: step.id)
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Cancel timer")
        }
        .padding(.top, 6)
    }
}

private struct LiveTimerRowBackground: ViewModifier {
    let isLive: Bool
    let colorScheme: ColorScheme

    func body(content: Content) -> some View {
        if isLive {
            content.listRowBackground(Color.orange.opacity(colorScheme == .dark ? 0.22 : 0.12))
        } else {
            content
        }
    }
}
