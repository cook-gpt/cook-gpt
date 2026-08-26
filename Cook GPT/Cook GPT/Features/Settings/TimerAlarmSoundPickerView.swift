import SwiftUI

struct TimerAlarmSoundPickerView: View {
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        @Bindable var settings = settings

        List {
            if !TimerAlarmAudioEnvironment.supportsSystemAlarmPreviews {
                Section {
                    Text("Alarm previews need a physical iPhone. The Simulator does not include Clock alarm audio, so every preview plays the same placeholder chime. Your choice is saved and works on device.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                ForEach(TimerAlarmSound.allCases) { sound in
                    Button {
                        settings.timerAlarmSound = sound
                        TimerAlarmSoundPlayer.play(sound)
                    } label: {
                        HStack {
                            Text(sound.label)
                                .foregroundStyle(.primary)
                            Spacer()
                            if settings.timerAlarmSound == sound {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Timer alarm sound")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TimerAlarmSoundPickerView()
    }
    .environment(AppSettingsStore.shared)
}
