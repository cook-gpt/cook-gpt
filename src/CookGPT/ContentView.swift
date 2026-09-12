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

    @State private var showOnboarding = false

    @Query(filter: #Predicate<GroceryItem> { !$0.isChecked })
    private var pendingGroceryItems: [GroceryItem]

    private var pendingGroceryCount: Int {
        pendingGroceryItems.count
    }

    var body: some View {
        @Bindable var navigation = navigation

        TabView(selection: $navigation.selectedTab) {
            Tab("Recipes", systemImage: "book.closed", value: AppNavigationStore.Tab.recipes) {
                RecipesRootView()
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
        .onOpenURL { url in
            if let destination = AppDeepLink.recipeDestination(from: url) {
                navigation.openRecipe(id: destination.recipeID, stepID: destination.stepID)
            }
        }
        .onAppear {
            updateOnboardingPresentation()
        }
        .onChange(of: settings.hasCompletedOnboarding) { _, _ in
            updateOnboardingPresentation()
        }
        .onChange(of: settings.shouldPresentOnboarding) { _, _ in
            updateOnboardingPresentation()
        }
        .overlay {
            if showOnboarding {
                OnboardingView(
                    isReplay: settings.hasCompletedOnboarding,
                    onDismiss: {
                        showOnboarding = false
                    }
                )
                .transition(.opacity)
            }
        }
    }

    private func updateOnboardingPresentation() {
        showOnboarding = !settings.hasCompletedOnboarding || settings.shouldPresentOnboarding
    }
}

#Preview {
    ContentView()
        .environment(CookingSessionManager.shared)
        .environment(AppSettingsStore.shared)
        .environment(AppNavigationStore.shared)
        .modelContainer(try! CookGPTModelContainer.make())
}
