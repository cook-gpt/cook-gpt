//  ContentView.swift
//  CookGPT
//
//  Root tab bar: Recipes, Meals, Groceries, and Settings.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppSettingsStore.self) private var settings
    @Environment(CookingSessionManager.self) private var cookingSession
    @Environment(AppNavigationStore.self) private var navigation

    @Query(filter: #Predicate<GroceryItem> { !$0.isChecked })
    private var pendingGroceryItems: [GroceryItem]

    private var pendingGroceryCount: Int {
        pendingGroceryItems.count
    }

    var body: some View {
        @Bindable var navigation = navigation

        TabView(selection: $navigation.selectedTab) {
            Tab("Recipes", systemImage: "book.closed", value: AppNavigationStore.Tab.recipes) {
                NavigationStack {
                    RecipesRootView()
                }
            }
            .badge(cookingSession.showsRecipesTabBadge ? Text(verbatim: "") : nil)

            Tab("Meals", systemImage: "calendar", value: AppNavigationStore.Tab.meals) {
                NavigationStack {
                    DietRootView()
                }
            }

            Tab("Groceries", systemImage: "cart", value: AppNavigationStore.Tab.groceries) {
                NavigationStack {
                    GroceriesRootView()
                }
            }
            .badge(pendingGroceryCount)

            Tab("Settings", systemImage: "gearshape", value: AppNavigationStore.Tab.settings) {
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
        .environment(AppNavigationStore.shared)
        .modelContainer(try! CookGPTModelContainer.make())
}
