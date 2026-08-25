import Foundation
import SwiftData

enum SampleDataSeeder {
    private static let seedFlagKey = "didSeedSampleData"
    private static let recipeStructureVersionKey = "sampleRecipeStructureVersion"
    private static let currentRecipeStructureVersion = 4

    static func seedIfNeeded(context: ModelContext) {
        if !UserDefaults.standard.bool(forKey: seedFlagKey) {
            let recipeDescriptor = FetchDescriptor<Recipe>()
            let existingRecipes = (try? context.fetch(recipeDescriptor)) ?? []
            if existingRecipes.isEmpty {
                seed(context: context)
            }
            UserDefaults.standard.set(true, forKey: seedFlagKey)
        }

        upgradeRecipeStructureIfNeeded(context: context)
    }

    private static func upgradeRecipeStructureIfNeeded(context: ModelContext) {
        let version = UserDefaults.standard.integer(forKey: recipeStructureVersionKey)
        guard version < currentRecipeStructureVersion else { return }

        let descriptor = FetchDescriptor<Recipe>()
        let recipes = (try? context.fetch(descriptor)) ?? []

        for recipe in recipes {
            rebuildRecipeSteps(recipe: recipe, context: context)
        }

        try? context.save()
        UserDefaults.standard.set(currentRecipeStructureVersion, forKey: recipeStructureVersionKey)
    }

    private static func seed(context: ModelContext) {
        let tomato = Ingredient(name: "Tomato", category: .produce)
        let garlic = Ingredient(name: "Garlic", category: .produce)
        let oliveOil = Ingredient(name: "Olive oil", category: .other)
        let pasta = Ingredient(name: "Spaghetti", category: .grain)
        let parmesan = Ingredient(name: "Parmesan", category: .dairy)
        let chicken = Ingredient(name: "Chicken breast", category: .protein)
        let rice = Ingredient(name: "Brown rice", category: .grain)
        let broccoli = Ingredient(name: "Broccoli", category: .produce)

        let ingredients = [tomato, garlic, oliveOil, pasta, parmesan, chicken, rice, broccoli]
        ingredients.forEach { context.insert($0) }

        context.insert(makeAglioOlioRecipe(pasta: pasta, garlic: garlic, oliveOil: oliveOil, context: context))
        context.insert(makeChickenBowlRecipe(chicken: chicken, rice: rice, broccoli: broccoli, oliveOil: oliveOil, context: context))

        let profile = DietProfile(
            name: "Balanced",
            dailyCalorieGoal: 2000,
            proteinGrams: 120,
            carbGrams: 250,
            fatGrams: 65,
            isActive: true
        )
        context.insert(profile)

        let groceryList = GroceryList(name: "Weekly shop")
        context.insert(groceryList)

        let groceryItems = [
            GroceryItem(name: "Tomatoes", quantity: 6, unit: "pcs", list: groceryList),
            GroceryItem(name: "Chicken breast", quantity: 500, unit: "g", list: groceryList),
            GroceryItem(name: "Brown rice", quantity: 1, unit: "kg", list: groceryList),
            GroceryItem(name: "Broccoli", quantity: 2, unit: "heads", list: groceryList),
        ]
        groceryItems.forEach { context.insert($0) }
        groceryList.items = groceryItems

        let pantryItems = [
            PantryItem(name: "Olive oil", quantity: 500, unit: "ml", ingredient: oliveOil),
            PantryItem(
                name: "Parmesan",
                quantity: 200,
                unit: "g",
                expiresOn: Calendar.current.date(byAdding: .day, value: 14, to: .now),
                ingredient: parmesan
            ),
        ]
        pantryItems.forEach { context.insert($0) }

        try? context.save()
        UserDefaults.standard.set(currentRecipeStructureVersion, forKey: recipeStructureVersionKey)
    }

    private static func rebuildRecipeSteps(recipe: Recipe, context: ModelContext) {
        recipe.steps.forEach { context.delete($0) }
        recipe.steps = []

        switch recipe.title {
        case "Spaghetti Aglio e Olio":
            recipe.steps = makeAglioOlioSteps(recipe: recipe, context: context)
        case "Chicken & Broccoli Rice Bowl":
            recipe.steps = makeChickenBowlSteps(recipe: recipe, context: context)
        default:
            break
        }
    }

    private static func makeAglioOlioRecipe(
        pasta: Ingredient,
        garlic: Ingredient,
        oliveOil: Ingredient,
        context: ModelContext
    ) -> Recipe {
        let recipe = Recipe(
            title: "Spaghetti Aglio e Olio",
            summary: "Classic garlic and olive oil pasta — quick weeknight dinner.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["vegetarian", "quick", "italian"]
        )

        let recipeIngredients = [
            RecipeIngredient(quantity: 200, unit: "g", ingredient: pasta, recipe: recipe),
            RecipeIngredient(quantity: 4, unit: "cloves", ingredient: garlic, recipe: recipe),
            RecipeIngredient(quantity: 3, unit: "tbsp", ingredient: oliveOil, recipe: recipe),
        ]
        recipeIngredients.forEach { context.insert($0) }
        recipe.ingredients = recipeIngredients
        recipe.steps = makeAglioOlioSteps(recipe: recipe, context: context)
        return recipe
    }

    private static func makeAglioOlioSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        let cookPasta = RecipeStep(
            order: 0,
            instruction: "Boil salted water and cook spaghetti until al dente.",
            timerSeconds: 600,
            recipe: recipe
        )
        context.insert(cookPasta)

        let garlicOil = RecipeStep(
            order: 1,
            instruction: "Slice garlic thinly and gently sauté in olive oil until fragrant.",
            timerSeconds: 180,
            recipe: recipe
        )
        context.insert(garlicOil)

        let finish = RecipeStep(
            order: 2,
            instruction: "Toss drained pasta with the garlic oil. Season and serve.",
            recipe: recipe
        )
        context.insert(finish)

        return [cookPasta, garlicOil, finish]
    }

    private static func makeChickenBowlRecipe(
        chicken: Ingredient,
        rice: Ingredient,
        broccoli: Ingredient,
        oliveOil: Ingredient,
        context: ModelContext
    ) -> Recipe {
        let recipe = Recipe(
            title: "Chicken & Broccoli Rice Bowl",
            summary: "Balanced bowl with lean protein and greens.",
            servings: 2,
            prepMinutes: 15,
            cookMinutes: 25,
            difficulty: .medium,
            tags: ["high-protein", "meal-prep"]
        )

        let recipeIngredients = [
            RecipeIngredient(quantity: 2, unit: "pieces", ingredient: chicken, recipe: recipe),
            RecipeIngredient(quantity: 1, unit: "cup", ingredient: rice, recipe: recipe),
            RecipeIngredient(quantity: 200, unit: "g", ingredient: broccoli, recipe: recipe),
            RecipeIngredient(quantity: 1, unit: "tbsp", ingredient: oliveOil, recipe: recipe),
        ]
        recipeIngredients.forEach { context.insert($0) }
        recipe.ingredients = recipeIngredients
        recipe.steps = makeChickenBowlSteps(recipe: recipe, context: context)
        return recipe
    }

    private static func makeChickenBowlSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        let cookRice = RecipeStep(
            order: 0,
            instruction: "Cook brown rice according to package directions.",
            timerSeconds: 1200,
            recipe: recipe
        )
        context.insert(cookRice)

        let searChicken = RecipeStep(
            order: 1,
            instruction: "Season chicken and pan-sear until cooked through.",
            timerSeconds: 480,
            recipe: recipe
        )
        context.insert(searChicken)

        let steamBroccoli = RecipeStep(
            order: 2,
            instruction: "Steam broccoli until tender-crisp.",
            timerSeconds: 300,
            recipe: recipe
        )
        context.insert(steamBroccoli)

        let assemble = RecipeStep(
            order: 3,
            instruction: "Slice chicken and assemble bowls with rice and broccoli.",
            recipe: recipe
        )
        context.insert(assemble)

        return [cookRice, searChicken, steamBroccoli, assemble]
    }
}
