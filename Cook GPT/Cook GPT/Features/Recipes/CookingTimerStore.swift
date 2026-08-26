import Foundation
import SwiftUI

@Observable
@MainActor
final class CookingTimerStore {
    enum TimerPhase: String, Codable {
        case running
        case paused
    }

    struct RunningTimer: Identifiable, Codable {
        let id: UUID
        let stepID: UUID
        let recipeID: UUID
        let recipeTitle: String
        let label: String
        var phase: TimerPhase
        var endsAt: Date?
        var remainingSeconds: Int

        enum CodingKeys: String, CodingKey {
            case id, stepID, recipeID, recipeTitle, label, phase, endsAt, remainingSeconds
        }

        init(
            id: UUID,
            stepID: UUID,
            recipeID: UUID,
            recipeTitle: String,
            label: String,
            phase: TimerPhase,
            endsAt: Date?,
            remainingSeconds: Int
        ) {
            self.id = id
            self.stepID = stepID
            self.recipeID = recipeID
            self.recipeTitle = recipeTitle
            self.label = label
            self.phase = phase
            self.endsAt = endsAt
            self.remainingSeconds = remainingSeconds
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            stepID = try container.decode(UUID.self, forKey: .stepID)
            recipeID = try container.decode(UUID.self, forKey: .recipeID)
            recipeTitle = try container.decodeIfPresent(String.self, forKey: .recipeTitle) ?? "Cook GPT"
            label = try container.decode(String.self, forKey: .label)
            phase = try container.decode(TimerPhase.self, forKey: .phase)
            endsAt = try container.decodeIfPresent(Date.self, forKey: .endsAt)
            remainingSeconds = try container.decode(Int.self, forKey: .remainingSeconds)
        }

        var displayRemaining: Int {
            switch phase {
            case .running:
                guard let endsAt else { return remainingSeconds }
                return max(0, Int(endsAt.timeIntervalSinceNow.rounded(.up)))
            case .paused:
                return remainingSeconds
            }
        }

        var isFinished: Bool {
            phase == .running && displayRemaining == 0
        }

        var isLive: Bool {
            phase == .running && !isFinished
        }
    }

    private(set) var timers: [RunningTimer] = []
    private let persistenceKey = "activeCookingTimers"

    var activeTimers: [RunningTimer] {
        timers.filter { !$0.isFinished }
    }

    func timers(for recipeID: UUID) -> [RunningTimer] {
        activeTimers.filter { $0.recipeID == recipeID }
    }

    func timer(for stepID: UUID) -> RunningTimer? {
        activeTimers.first { $0.stepID == stepID }
    }

    func isLive(stepID: UUID) -> Bool {
        timer(for: stepID)?.isLive == true
    }

    func hasTimer(stepID: UUID) -> Bool {
        timer(for: stepID) != nil
    }

    func start(stepID: UUID, recipeID: UUID, recipeTitle: String, label: String, duration: Int) {
        stop(stepID: stepID)
        guard duration > 0 else { return }

        timers.append(
            RunningTimer(
                id: UUID(),
                stepID: stepID,
                recipeID: recipeID,
                recipeTitle: recipeTitle,
                label: label,
                phase: .running,
                endsAt: .now.addingTimeInterval(TimeInterval(duration)),
                remainingSeconds: duration
            )
        )
        persistAndSyncLiveActivity(stepID: stepID)
    }

    func pause(stepID: UUID) {
        guard let index = timers.firstIndex(where: { $0.stepID == stepID && $0.phase == .running }) else { return }
        var timer = timers[index]
        timer.remainingSeconds = timer.displayRemaining
        timer.phase = .paused
        timer.endsAt = nil
        timers[index] = timer
        persistAndSyncLiveActivity(stepID: stepID)
    }

    func resume(stepID: UUID) {
        guard let index = timers.firstIndex(where: { $0.stepID == stepID && $0.phase == .paused }) else { return }
        var timer = timers[index]
        guard timer.remainingSeconds > 0 else { return }
        timer.phase = .running
        timer.endsAt = .now.addingTimeInterval(TimeInterval(timer.remainingSeconds))
        timers[index] = timer
        persistAndSyncLiveActivity(stepID: stepID)
    }

    func stop(stepID: UUID) {
        guard timer(for: stepID) != nil else { return }
        timers.removeAll { $0.stepID == stepID }
        persist()
        Task { await CookingTimerLiveActivityManager.end(stepID: stepID) }
    }

    func stop(timerID: UUID) {
        guard timers.contains(where: { $0.id == timerID }) else { return }
        timers.removeAll { $0.id == timerID }
        persist()
        Task { await CookingTimerLiveActivityManager.end(timerID: timerID) }
    }

    func stopAll(for recipeID: UUID) {
        let active = timers.filter { $0.recipeID == recipeID }
        guard !active.isEmpty else { return }
        timers.removeAll { $0.recipeID == recipeID }
        persist()
        for timer in active {
            Task { await CookingTimerLiveActivityManager.end(stepID: timer.stepID) }
        }
    }

    func pruneFinished() {
        let before = timers.count
        let finished = timers.filter(\.isFinished)
        timers.removeAll { $0.isFinished }
        if timers.count != before {
            persist()
            for timer in finished {
                Task { await CookingTimerLiveActivityManager.end(stepID: timer.stepID) }
            }
        }
    }

    func loadPersisted() {
        guard let data = UserDefaults.standard.data(forKey: persistenceKey),
              let decoded = try? JSONDecoder().decode([RunningTimer].self, from: data) else { return }
        timers = decoded.filter { !$0.isFinished }
        let restored = timers
        Task {
            await CookingTimerLiveActivityManager.restore(timers: restored)
        }
    }

    func clearAll() {
        timers = []
        UserDefaults.standard.removeObject(forKey: persistenceKey)
        Task {
            await CookingTimerLiveActivityManager.endAll()
        }
    }

    private func persist() {
        pruneFinished()
        if let data = try? JSONEncoder().encode(timers) {
            UserDefaults.standard.set(data, forKey: persistenceKey)
        }
    }

    private func persistAndSyncLiveActivity(stepID: UUID) {
        persist()
        guard let timer = timer(for: stepID) else { return }
        Task {
            await CookingTimerLiveActivityManager.sync(timer: timer, recipeTitle: timer.recipeTitle)
        }
    }
}

enum TimerFormatting {
    static func string(seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", minutes, secs)
    }
}
