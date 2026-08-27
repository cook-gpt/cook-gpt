//  ContentView.swift
//  Cook GPT
//
//  Root tab bar: Recipes, Meals, Groceries, and Settings.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppSettingsStore.self) private var settings

    var body: some View {
        TabView {
            Tab("Recipes", systemImage: "book.closed") {
                NavigationStack {
                    RecipesRootView()
                }
            }

            Tab("Meals", systemImage: "calendar") {
                NavigationStack {
                    DietRootView()
                }
            }

            Tab("Groceries", systemImage: "cart") {
                NavigationStack {
                    GroceriesRootView()
                }
            }

            Tab("Settings", systemImage: "gearshape") {
                NavigationStack {
                    SettingsRootView()
                }
            }
        }
        .preferredColorScheme(settings.appTheme.colorScheme)
        .id(settings.contentResetID)
    }
}

#Preview {
    ContentView()
        .environment(CookingSessionManager.shared)
        .environment(AppSettingsStore.shared)
        .modelContainer(try! CookGPTModelContainer.make())
}
