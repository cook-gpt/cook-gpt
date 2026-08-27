//  CookingTimerLiveActivityManager.swift
//  Cook GPT
//
//  Starts and updates cooking timer Live Activities.
//

import ActivityKit
import Foundation

@MainActor
enum CookingTimerLiveActivityManager {
    private static var activitiesByStepID: [UUID: Activity<CookingTimerAttributes>] = [:]

    static var areActivitiesEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }

    static func sync(timer: CookingTimerStore.RunningTimer, recipeTitle: String) async {
        guard areActivitiesEnabled else { return }

        let contentState = contentState(for: timer, recipeTitle: recipeTitle)
        let attributes = CookingTimerAttributes(timerID: timer.id.uuidString)

        if let activity = activitiesByStepID[timer.stepID] {
            await activity.update(ActivityContent(state: contentState, staleDate: nil))
            return
        }

        if let existing = Activity<CookingTimerAttributes>.activities.first(where: {
            $0.content.state.stepID == timer.stepID.uuidString
        }) {
            activitiesByStepID[timer.stepID] = existing
            await existing.update(ActivityContent(state: contentState, staleDate: nil))
            return
        }

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: contentState, staleDate: nil),
                pushType: nil
            )
            activitiesByStepID[timer.stepID] = activity
        } catch {
            // Live Activities require a supported device and user permission.
        }
    }

    static func end(stepID: UUID) async {
        if let activity = activitiesByStepID.removeValue(forKey: stepID) {
            await activity.end(nil, dismissalPolicy: .immediate)
            return
        }

        for activity in Activity<CookingTimerAttributes>.activities where activity.content.state.stepID == stepID.uuidString {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    static func end(timerID: UUID) async {
        if let entry = activitiesByStepID.first(where: { $0.value.attributes.timerID == timerID.uuidString }) {
            activitiesByStepID.removeValue(forKey: entry.key)
            await entry.value.end(nil, dismissalPolicy: .immediate)
            return
        }

        for activity in Activity<CookingTimerAttributes>.activities where activity.attributes.timerID == timerID.uuidString {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    static func restore(timers: [CookingTimerStore.RunningTimer]) async {
        for activity in Activity<CookingTimerAttributes>.activities {
            let stepID = UUID(uuidString: activity.content.state.stepID)
            if let stepID, !timers.contains(where: { $0.stepID == stepID }) {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }

        for timer in timers {
            await sync(timer: timer, recipeTitle: timer.recipeTitle)
        }
    }

    static func endAll() async {
        activitiesByStepID.removeAll()
        for activity in Activity<CookingTimerAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    private static func contentState(
        for timer: CookingTimerStore.RunningTimer,
        recipeTitle: String
    ) -> CookingTimerAttributes.ContentState {
        CookingTimerAttributes.ContentState(
            stepID: timer.stepID.uuidString,
            recipeTitle: recipeTitle,
            stepLabel: timer.label,
            phase: timer.phase.rawValue,
            endsAt: timer.endsAt,
            remainingSeconds: timer.displayRemaining
        )
    }
}
