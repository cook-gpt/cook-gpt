import AVFoundation
import Foundation

enum TimerAlarmSoundInstaller {
    @discardableResult
    static func ensureInstalled(_ sound: TimerAlarmSound) -> String? {
        guard let sourceURL = SystemToneLibrary.alarmPlaybackURL(for: sound) else { return nil }

        let soundsDirectory = librarySoundsDirectory()
        try? FileManager.default.createDirectory(at: soundsDirectory, withIntermediateDirectories: true)

        let destinationURL = soundsDirectory.appendingPathComponent(sound.notificationSoundFileName)
        if FileManager.default.fileExists(atPath: destinationURL.path),
           isUpToDate(sourceURL: sourceURL, destinationURL: destinationURL) {
            return sound.notificationSoundFileName
        }

        if sourceURL.pathExtension.lowercased() == "caf" {
            try? FileManager.default.removeItem(at: destinationURL)
            do {
                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                return sound.notificationSoundFileName
            } catch {
                return nil
            }
        }

        return convertToCAF(sourceURL: sourceURL, destinationURL: destinationURL)
            ? sound.notificationSoundFileName
            : nil
    }

    private static func isUpToDate(sourceURL: URL, destinationURL: URL) -> Bool {
        guard let sourceValues = try? sourceURL.resourceValues(forKeys: [.contentModificationDateKey]),
              let destinationValues = try? destinationURL.resourceValues(forKeys: [.contentModificationDateKey]),
              let sourceDate = sourceValues.contentModificationDate,
              let destinationDate = destinationValues.contentModificationDate else {
            return FileManager.default.fileExists(atPath: destinationURL.path)
        }
        return destinationDate >= sourceDate
    }

    private static func convertToCAF(sourceURL: URL, destinationURL: URL) -> Bool {
        do {
            let sourceFile = try AVAudioFile(forReading: sourceURL)
            let format = sourceFile.processingFormat
            let frameCount = AVAudioFrameCount(sourceFile.length)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                return false
            }
            try sourceFile.read(into: buffer)

            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }

            let outputFile = try AVAudioFile(
                forWriting: destinationURL,
                settings: format.settings,
                commonFormat: format.commonFormat,
                interleaved: format.isInterleaved
            )
            try outputFile.write(from: buffer)
            return true
        } catch {
            return false
        }
    }

    private static func librarySoundsDirectory() -> URL {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Sounds", isDirectory: true)
    }
}
