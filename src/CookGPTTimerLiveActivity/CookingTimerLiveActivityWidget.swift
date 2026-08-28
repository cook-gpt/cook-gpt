//  CookingTimerLiveActivityWidget.swift
//  CookGPT
//
//  Lock Screen and Dynamic Island UI for cooking timers.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct CookingTimerLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CookingTimerAttributes.self) { context in
            CookingTimerLiveActivityView(context: context)
                .activityBackgroundTint(Color.orange.opacity(0.15))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.phase == "paused" ? "pause.circle.fill" : "timer")
                        .foregroundStyle(.orange)
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 2) {
                        Text(context.state.stepLabel)
                            .font(.caption)
                            .lineLimit(1)
                        timerText(for: context.state)
                            .font(.title3.monospacedDigit().weight(.semibold))
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.recipeTitle)
                        .font(.caption2)
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundStyle(.orange)
            } compactTrailing: {
                timerText(for: context.state)
                    .monospacedDigit()
                    .font(.caption2.weight(.semibold))
            } minimal: {
                Image(systemName: "timer")
                    .foregroundStyle(.orange)
            }
        }
    }

    @ViewBuilder
    private func timerText(for state: CookingTimerAttributes.ContentState) -> some View {
        if state.phase == "running", let endsAt = state.endsAt {
            Text(timerInterval: Date.now...endsAt, countsDown: true)
        } else {
            Text(formatted(seconds: state.remainingSeconds))
        }
    }

    private func formatted(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}

struct CookingTimerLiveActivityView: View {
    let context: ActivityViewContext<CookingTimerAttributes>

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: context.state.phase == "paused" ? "pause.circle.fill" : "timer")
                .font(.title2)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text(context.state.recipeTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(context.state.stepLabel)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                if context.state.phase == "paused" {
                    Text("Paused · \(formatted(seconds: context.state.remainingSeconds))")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                } else if let endsAt = context.state.endsAt {
                    Text(timerInterval: Date.now...endsAt, countsDown: true)
                        .font(.title2.monospacedDigit().weight(.bold))
                        .foregroundStyle(.orange)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
    }

    private func formatted(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
