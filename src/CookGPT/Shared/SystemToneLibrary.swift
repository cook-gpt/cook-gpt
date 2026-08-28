//  SystemToneLibrary.swift
//  CookGPT
//
//  Resolves and plays built-in iPhone Clock alarm tones on device.
//

import AudioToolbox
import AVFoundation
import Foundation

/// Resolves and plays built-in iPhone Clock alarm tones.
///
/// On a physical device, tones are loaded through Apple's ToneLibrary framework
/// (the same source as the Clock app). The Simulator does not expose those assets,
/// so previews fall back to a generic alarm chime.
enum SystemToneLibrary {
    private static let alarmAlertType = 13 // TLAlertTypeAlarm
    private static let ringtoneDirectory = "/Library/Ringtones"

    private static let toneManager: NSObject? = {
        guard TimerAlarmAudioEnvironment.supportsSystemAlarmPreviews,
              let managerClass = NSClassFromString("TLToneManager") as? NSObject.Type else {
            return nil
        }

        let sharedSelector = NSSelectorFromString("sharedInstance")
        if managerClass.responds(to: sharedSelector),
           let shared = managerClass.perform(sharedSelector)?.takeUnretainedValue() as? NSObject {
            return shared
        }
        return managerClass.init()
    }()

    @MainActor
    static func play(_ sound: TimerAlarmSound, player: inout AVAudioPlayer?) {
        player?.stop()
        player = nil
        configureAlarmAudioSession()

        guard TimerAlarmAudioEnvironment.supportsSystemAlarmPreviews else {
            AudioServicesPlayAlertSound(TimerAlarmAudioEnvironment.simulatorPreviewSoundID)
            return
        }

        if let url = alarmPlaybackURL(for: sound),
           playFile(at: url, player: &player) {
            return
        }

        if playThroughToneLibrary(for: sound) {
            return
        }

        AudioServicesPlayAlertSound(TimerAlarmAudioEnvironment.simulatorPreviewSoundID)
    }

    static func alarmPlaybackURL(for sound: TimerAlarmSound) -> URL? {
        guard TimerAlarmAudioEnvironment.supportsSystemAlarmPreviews else { return nil }

        if let url = soundFileURL(from: toneObject(for: sound)) {
            return url
        }

        if let identifier = resolvedToneIdentifier(for: sound),
           let path = filePath(forToneIdentifier: identifier),
           !path.isEmpty {
            return URL(fileURLWithPath: path)
        }

        for name in sound.fileNameCandidates {
            let ringtonePath = "\(ringtoneDirectory)/\(name).m4r"
            if FileManager.default.fileExists(atPath: ringtonePath) {
                return URL(fileURLWithPath: ringtonePath)
            }
        }

        return nil
    }

    @MainActor
    private static func playFile(at url: URL, player: inout AVAudioPlayer?) -> Bool {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            return true
        } catch {
            return false
        }
    }

    private static func playThroughToneLibrary(for sound: TimerAlarmSound) -> Bool {
        guard let toneIdentifier = resolvedToneIdentifier(for: sound),
              let configuration = makeAlertConfiguration(toneIdentifier: toneIdentifier),
              let alertClass = NSClassFromString("TLAlert") as? NSObject.Type,
              let alert = ObjCRuntime.performClass(
                alertClass,
                selector: "alertWithConfiguration:",
                argument: configuration
              ) as? NSObject else {
            return false
        }

        let playSelector = NSSelectorFromString("playWithCompletionHandler:")
        guard alert.responds(to: playSelector) else { return false }

        _ = alert.perform(playSelector, with: nil)
        return true
    }

    private static func makeAlertConfiguration(toneIdentifier: String) -> NSObject? {
        guard let configurationClass = NSClassFromString("TLAlertConfiguration") as? NSObject.Type,
              let allocated = configurationClass.perform(NSSelectorFromString("alloc"))?.takeRetainedValue() as? NSObject,
              let configuration = ObjCRuntime.perform(
                allocated,
                selector: "initWithType:",
                argument: NSNumber(value: alarmAlertType)
              ) as? NSObject else {
            return nil
        }

        _ = ObjCRuntime.perform(configuration, selector: "setToneIdentifier:", argument: toneIdentifier)
        _ = ObjCRuntime.perform(configuration, selector: "setForPreview:", argument: NSNumber(value: true))
        _ = ObjCRuntime.perform(
            configuration,
            selector: "setShouldIgnoreRingerSwitch:",
            argument: NSNumber(value: true)
        )
        return configuration
    }

    private static func resolvedToneIdentifier(for sound: TimerAlarmSound) -> String? {
        for candidate in sound.toneIdentifierCandidates {
            if let path = filePath(forToneIdentifier: candidate), !path.isEmpty {
                return candidate
            }
            if let name = nameForToneIdentifier(candidate),
               namesAreEquivalent(name, sound.label) {
                return candidate
            }
        }

        guard let manager = toneManager,
              let allTones = manager.value(forKey: "_tonesByIdentifier") as? [String: Any] else {
            return nil
        }

        let target = sound.resourceName.lowercased()
        let label = sound.label.lowercased()

        for key in allTones.keys.sorted() {
            let keyLower = key.lowercased()
            guard keyLower.contains(target) || keyLower.contains(label.replacingOccurrences(of: " ", with: "_")) else {
                continue
            }

            if let name = nameForToneIdentifier(key), namesAreEquivalent(name, sound.label) {
                return key
            }
        }

        return nil
    }

    private static func toneObject(for sound: TimerAlarmSound) -> NSObject? {
        guard let manager = toneManager,
              let identifier = resolvedToneIdentifier(for: sound) else {
            return nil
        }
        return ObjCRuntime.perform(manager, selector: "_toneWithIdentifier:", argument: identifier) as? NSObject
    }

    private static func soundFileURL(from tone: NSObject?) -> URL? {
        guard let tone else { return nil }

        if let actualSound = tone.value(forKey: "actualSound") as? NSObject,
           let url = soundFileURL(from: actualSound) {
            return url
        }

        if let previewSound = tone.value(forKey: "previewSound") as? NSObject,
           let url = soundFileURL(from: previewSound) {
            return url
        }

        if let url = tone.value(forKey: "soundFileURL") as? URL,
           FileManager.default.fileExists(atPath: url.path) {
            return url
        }

        return nil
    }

    private static func filePath(forToneIdentifier identifier: String) -> String? {
        guard let manager = toneManager else { return nil }
        return ObjCRuntime.perform(manager, selector: "filePathForToneIdentifier:", argument: identifier) as? String
    }

    private static func nameForToneIdentifier(_ identifier: String) -> String? {
        guard let manager = toneManager else { return nil }
        return ObjCRuntime.perform(manager, selector: "nameForToneIdentifier:", argument: identifier) as? String
    }

    private static func namesAreEquivalent(_ lhs: String, _ rhs: String) -> Bool {
        let normalizedLHS = lhs.replacingOccurrences(of: "_", with: " ")
        let normalizedRHS = rhs.replacingOccurrences(of: "_", with: " ")
        return normalizedLHS.compare(normalizedRHS, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    }

    @MainActor
    private static func configureAlarmAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category(rawValue: "AVAudioSessionCategoryAlarm"), mode: .default)
        } catch {
            try? session.setCategory(.playback, mode: .default, options: [.duckOthers])
        }
        try? session.setActive(true)
    }
}

private enum ObjCRuntime {
    static func performClass(_ objectClass: NSObject.Type, selector name: String, argument: Any? = nil) -> Any? {
        let selector = NSSelectorFromString(name)
        guard objectClass.responds(to: selector) else { return nil }

        let result: Unmanaged<AnyObject>?
        if let argument {
            result = objectClass.perform(selector, with: argument)
        } else {
            result = objectClass.perform(selector)
        }

        return result?.takeUnretainedValue()
    }

    static func perform(_ object: NSObject, selector name: String, argument: Any? = nil) -> Any? {
        let selector = NSSelectorFromString(name)
        guard object.responds(to: selector) else { return nil }

        let result: Unmanaged<AnyObject>?
        if let argument {
            result = object.perform(selector, with: argument)
        } else {
            result = object.perform(selector)
        }

        return result?.takeUnretainedValue()
    }
}
