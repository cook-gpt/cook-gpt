//  TimerAlarmSoundPlayer.swift
//  Cook GPT
//
//  Plays alarm sounds for previews and completion.
//

import AVFoundation
import Foundation

@MainActor
enum TimerAlarmSoundPlayer {
    private static var player: AVAudioPlayer?

    static func play(_ sound: TimerAlarmSound) {
        SystemToneLibrary.play(sound, player: &player)
    }
}
