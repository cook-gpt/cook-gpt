//  TimerAlarmSound.swift
//  Cook GPT
//
//  Clock-style alarm identifiers for timer completion audio.
//

import Foundation

/// iPhone Clock alarm names. Audio is resolved on device through system ToneLibrary.
enum TimerAlarmSound: String, Codable, Identifiable, Hashable {
    case radar
    case apex
    case beacon
    case bulletin
    case chimes
    case circuit
    case constellation
    case cosmic
    case crystals
    case hillside
    case illuminate
    case nightOwl = "night-owl"
    case opening
    case playtime
    case presto
    case reflection
    case ripples
    case sencha
    case signal
    case silk
    case slowRise = "slow-rise"
    case stargaze
    case summit
    case twinkle
    case uplift
    case waves

    var id: String { rawValue }

    static let allCases: [TimerAlarmSound] = [
        .radar,
        .apex,
        .beacon,
        .bulletin,
        .chimes,
        .circuit,
        .constellation,
        .cosmic,
        .crystals,
        .hillside,
        .illuminate,
        .nightOwl,
        .opening,
        .playtime,
        .presto,
        .reflection,
        .ripples,
        .sencha,
        .signal,
        .silk,
        .slowRise,
        .stargaze,
        .summit,
        .twinkle,
        .uplift,
        .waves,
    ]

    var label: String {
        switch self {
        case .nightOwl: "Night Owl"
        case .slowRise: "Slow Rise"
        default:
            rawValue
                .replacingOccurrences(of: "-", with: " ")
                .capitalized
        }
    }

    var resourceName: String {
        switch self {
        case .nightOwl: "Night_Owl"
        case .slowRise: "Slow_Rise"
        default:
            rawValue
                .split(separator: "-")
                .map { part in
                    part.prefix(1).uppercased() + part.dropFirst()
                }
                .joined(separator: "_")
        }
    }

    var fileNameCandidates: [String] {
        let spaced = label
        let underscored = label.replacingOccurrences(of: " ", with: "_")
        return [resourceName, spaced, underscored]
    }

    var toneIdentifierCandidates: [String] {
        let name = resourceName
        let spaced = label
        return [
            "system:\(name)",
            "system:\(spaced)",
            name,
            spaced,
        ]
    }

    var notificationSoundFileName: String {
        "timer-alarm-\(rawValue).caf"
    }

    static var defaultSound: TimerAlarmSound { .radar }
}
