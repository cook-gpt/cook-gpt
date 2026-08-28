//  TimerCompletionNotifier.swift
//  CookGPT
//
//  Schedules local notifications when timers finish.
//

import Foundation
import UserNotifications

enum TimerCompletionNotifier {
    private static let categoryID = "cooking-timer-complete"

    static func requestAuthorizationIfNeeded() async {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .notDetermined else { return }
        _ = try? await center.requestAuthorization(options: [.alert, .sound])
    }

    static func schedule(
        stepID: UUID,
        recipeTitle: String,
        stepLabel: String,
        fireDate: Date,
        sound: TimerAlarmSound
    ) async {
        await requestAuthorizationIfNeeded()
        cancel(stepID: stepID)

        let content = UNMutableNotificationContent()
        content.title = "Timer finished"
        content.body = "\(recipeTitle) — \(stepLabel)"
        content.sound = notificationSound(for: sound)
        content.categoryIdentifier = categoryID

        let interval = max(1, fireDate.timeIntervalSinceNow)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(
            identifier: notificationIdentifier(for: stepID),
            content: content,
            trigger: trigger
        )

        try? await UNUserNotificationCenter.current().add(request)
    }

    static func cancel(stepID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [notificationIdentifier(for: stepID)]
        )
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private static func notificationIdentifier(for stepID: UUID) -> String {
        "cooking-timer.\(stepID.uuidString)"
    }

    private static func notificationSound(for sound: TimerAlarmSound) -> UNNotificationSound {
        guard TimerAlarmAudioEnvironment.supportsSystemAlarmPreviews,
              let installed = TimerAlarmSoundInstaller.ensureInstalled(sound) else {
            return .default
        }
        return UNNotificationSound(named: UNNotificationSoundName(installed))
    }
}
