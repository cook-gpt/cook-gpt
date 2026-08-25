import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Recipes", systemImage: "book.closed") {
                NavigationStack {
                    RecipesRootView()
                }
            }

            Tab("Diet", systemImage: "heart.text.square") {
                NavigationStack {
                    DietRootView()
                }
            }

            Tab("Groceries", systemImage: "cart") {
                NavigationStack {
                    GroceriesRootView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(CookingSessionManager.shared)
        .modelContainer(try! CookGPTModelContainer.make())
}
