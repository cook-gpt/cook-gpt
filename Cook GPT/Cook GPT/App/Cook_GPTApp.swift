import SwiftUI
import SwiftData

@main
struct Cook_GPTApp: App {
    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try CookGPTModelContainer.make()
        } catch {
            fatalError("Failed to create model container after recovery: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(CookingSessionManager.shared)
                .environment(AppSettingsStore.shared)
                .onAppear {
                    let context = modelContainer.mainContext
                    SampleDataSeeder.seedIfNeeded(context: context)
                }
        }
        .modelContainer(modelContainer)
    }
}
