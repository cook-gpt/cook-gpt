//  TimerAlarmAudioEnvironment.swift
//  CookGPT
//
//  Device vs Simulator capabilities for alarm previews.
//

import AudioToolbox
import Foundation

/// Capability flags for Clock-style alarm audio.
///
/// The Simulator does not ship the same ToneLibrary alarm assets as a physical iPhone.
/// Selection and persistence still work in Simulator; previews and custom notification
/// tones require a real device.
enum TimerAlarmAudioEnvironment {
    static var supportsSystemAlarmPreviews: Bool {
        #if targetEnvironment(simulator)
        false
        #else
        true
        #endif
    }

    /// Stand-in preview on Simulator where Clock alarm assets are unavailable.
    static let simulatorPreviewSoundID: SystemSoundID = 1304
}
