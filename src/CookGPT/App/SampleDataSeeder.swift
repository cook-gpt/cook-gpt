//  SampleDataSeeder.swift
//  CookGPT
//
//  Installs default recipes, diet profile, groceries, and meals; migrates sample data by version.
//

import Foundation
import SwiftData

enum SampleDataSeeder {
    private static let seedFlagKey = "didSeedSampleData"
    private static let recipeStructureVersionKey = "sampleRecipeStructureVersion"
    private static let currentRecipeStructureVersion = 8

    static func seedIfNeeded(context: ModelContext) {
        if !UserDefaults.standard.bool(forKey: seedFlagKey) {
            let recipeDescriptor = FetchDescriptor<Recipe>()
            let existingRecipes = (try? context.fetch(recipeDescriptor)) ?? []
            if existingRecipes.isEmpty {
                seedFreshInstall(context: context)
            }
            UserDefaults.standard.set(true, forKey: seedFlagKey)
        }

        upgradeRecipeStructureIfNeeded(context: context)
    }

    static func resetInstallFlags() {
        UserDefaults.standard.removeObject(forKey: seedFlagKey)
        UserDefaults.standard.removeObject(forKey: recipeStructureVersionKey)
    }

    static func seedFreshInstall(context: ModelContext) {
        var pool = IngredientPool(context: context)

        let recipes = [
            makeAglioOlioRecipe(pool: &pool, context: context),
            makeChickenBowlRecipe(pool: &pool, context: context),
            makeScrambledEggsRecipe(pool: &pool, context: context),
            makeGreekSaladRecipe(pool: &pool, context: context),
            makeLentilSoupRecipe(pool: &pool, context: context),
            makeSalmonRecipe(pool: &pool, context: context),
            makeOvernightOatsRecipe(pool: &pool, context: context),
            makeTomatoSoupRecipe(pool: &pool, context: context),
            makeBananaNiceCreamRecipe(pool: &pool, context: context),
        ]
        recipes.forEach { context.insert($0) }

        let profile = DietProfile(name: "Balanced", dietType: .balanced, isActive: true)
        context.insert(profile)

        let groceryList = GroceryList(name: "Shopping list")
        context.insert(groceryList)

        let today = MealScheduleCalendar.startOfDay(.now)
        let tomorrow = MealScheduleCalendar.calendar.date(byAdding: .day, value: 1, to: today) ?? today

        let sampleMeals = [
            ScheduledMeal(day: today, mealSlot: .lunch, recipe: recipes[0], servings: 1),
            ScheduledMeal(day: today, mealSlot: .dinner, recipe: recipes[1], servings: 1),
            ScheduledMeal(day: tomorrow, mealSlot: .lunch, recipe: recipes[2], servings: 1),
            ScheduledMeal(day: tomorrow, mealSlot: .dinner, recipe: recipes[5], servings: 1),
        ]
        sampleMeals.forEach { context.insert($0) }

        try? context.save()
        UserDefaults.standard.set(true, forKey: seedFlagKey)
        UserDefaults.standard.set(currentRecipeStructureVersion, forKey: recipeStructureVersionKey)
    }

    private static func upgradeRecipeStructureIfNeeded(context: ModelContext) {
        let version = UserDefaults.standard.integer(forKey: recipeStructureVersionKey)
        guard version < currentRecipeStructureVersion else { return }

        let descriptor = FetchDescriptor<Recipe>()
        let recipes = (try? context.fetch(descriptor)) ?? []

        for recipe in recipes {
            rebuildRecipeSteps(recipe: recipe, context: context)
            applyDefaultCategoryTags(recipe: recipe)
            applyDefaultCookingTools(recipe: recipe)
        }

        addMissingDefaultRecipesIfNeeded(context: context)

        try? context.save()
        UserDefaults.standard.set(currentRecipeStructureVersion, forKey: recipeStructureVersionKey)
    }

    private static func rebuildRecipeSteps(recipe: Recipe, context: ModelContext) {
        recipe.steps.forEach { context.delete($0) }
        recipe.steps = []

        switch recipe.title {
        case "Spaghetti Aglio e Olio":
            recipe.steps = aglioOlioSteps(recipe: recipe, context: context)
        case "Chicken & Broccoli Rice Bowl":
            recipe.steps = chickenBowlSteps(recipe: recipe, context: context)
        case "Classic Scrambled Eggs":
            recipe.steps = scrambledEggsSteps(recipe: recipe, context: context)
        case "Greek Salad":
            recipe.steps = greekSaladSteps(recipe: recipe, context: context)
        case "Hearty Lentil Soup":
            recipe.steps = lentilSoupSteps(recipe: recipe, context: context)
        case "Pan-Seared Salmon":
            recipe.steps = salmonSteps(recipe: recipe, context: context)
        case "Overnight Oats":
            recipe.steps = overnightOatsSteps(recipe: recipe, context: context)
        case "Tomato Basil Soup":
            recipe.steps = tomatoSoupSteps(recipe: recipe, context: context)
        case "Banana Nice Cream":
            recipe.steps = bananaNiceCreamSteps(recipe: recipe, context: context)
        default:
            break
        }
    }

    private static func applyDefaultCategoryTags(recipe: Recipe) {
        switch recipe.title {
        case "Classic Scrambled Eggs":
            recipe.tags = uniqueTags(recipe.tags + ["breakfast"])
        case "Overnight Oats":
            recipe.tags = uniqueTags(recipe.tags + ["breakfast"])
        case "Greek Salad":
            recipe.tags = uniqueTags(recipe.tags + ["no-fats"])
        case "Banana Nice Cream":
            recipe.tags = uniqueTags(recipe.tags + ["dessert", "vegan", "quick"])
        default:
            break
        }
    }

    private static func uniqueTags(_ tags: [String]) -> [String] {
        var seen = Set<String>()
        return tags.filter { seen.insert($0).inserted }
    }

    private static func cookingTools(_ tools: RecipeCookingTool...) -> [String] {
        tools.map(\.rawValue)
    }

    private static func applyDefaultCookingTools(recipe: Recipe) {
        switch recipe.title {
        case "Spaghetti Aglio e Olio":
            recipe.cookingTools = cookingTools(.pan)
        case "Chicken & Broccoli Rice Bowl":
            recipe.cookingTools = cookingTools(.pan)
        case "Classic Scrambled Eggs":
            recipe.cookingTools = cookingTools(.pan)
        case "Greek Salad":
            recipe.cookingTools = []
        case "Hearty Lentil Soup":
            recipe.cookingTools = cookingTools(.pan)
        case "Pan-Seared Salmon":
            recipe.cookingTools = cookingTools(.pan)
        case "Overnight Oats":
            recipe.cookingTools = cookingTools(.fridge)
        case "Tomato Basil Soup":
            recipe.cookingTools = cookingTools(.pan)
        case "Banana Nice Cream":
            recipe.cookingTools = cookingTools(.freezer)
        default:
            break
        }
    }

    private static func addMissingDefaultRecipesIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Recipe>()
        let recipes = (try? context.fetch(descriptor)) ?? []
        let titles = Set(recipes.map(\.title))

        guard !titles.contains("Banana Nice Cream") else { return }

        var pool = IngredientPool(context: context)
        let dessert = makeBananaNiceCreamRecipe(pool: &pool, context: context)
        context.insert(dessert)
    }


    private struct IngredientPool {
        let context: ModelContext
        private var cache: [String: Ingredient] = [:]

        init(context: ModelContext) {
            self.context = context
        }

        mutating func ingredient(_ name: String, category: IngredientCategory) -> Ingredient {
            if let existing = cache[name] { return existing }
            let item = Ingredient(name: name, category: category)
            context.insert(item)
            cache[name] = item
            return item
        }
    }

    // MARK: - Recipes

    private static func makeAglioOlioRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Spaghetti Aglio e Olio",
            summary: "Classic garlic and olive oil pasta — quick weeknight dinner.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["vegetarian", "quick", "italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (200, "g", pool.ingredient("Spaghetti", category: .grain)),
                (4, "tbsp", pool.ingredient("Garlic", category: .produce)),
                (3, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: aglioOlioSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeChickenBowlRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Chicken & Broccoli Rice Bowl",
            summary: "Balanced bowl with lean protein and greens.",
            servings: 2,
            prepMinutes: 15,
            cookMinutes: 25,
            difficulty: .medium,
            tags: ["high-protein", "meal-prep"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "pieces", pool.ingredient("Chicken breast", category: .protein)),
                (1, "cups", pool.ingredient("Brown rice", category: .grain)),
                (200, "g", pool.ingredient("Broccoli", category: .produce)),
                (1, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: chickenBowlSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeScrambledEggsRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Classic Scrambled Eggs",
            summary: "Fluffy eggs ready in minutes — perfect for breakfast.",
            servings: 2,
            prepMinutes: 5,
            cookMinutes: 5,
            difficulty: .easy,
            tags: ["vegetarian", "quick", "high-protein", "breakfast"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (4, "units", pool.ingredient("Eggs", category: .protein)),
                (2, "tbsp", pool.ingredient("Butter", category: .dairy)),
                (2, "tbsp", pool.ingredient("Milk", category: .dairy)),
            ],
            steps: scrambledEggsSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeGreekSaladRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Greek Salad",
            summary: "Crisp cucumbers, tomatoes, and feta with a lemon dressing.",
            servings: 2,
            prepMinutes: 15,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["vegetarian", "quick", "low-carbs", "no-fats"]
        )
        attach(
            recipe: recipe,
            ingredients: [
                (1, "units", pool.ingredient("Cucumber", category: .produce)),
                (2, "units", pool.ingredient("Tomato", category: .produce)),
                (100, "g", pool.ingredient("Feta cheese", category: .dairy)),
                (2, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: greekSaladSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeLentilSoupRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Hearty Lentil Soup",
            summary: "Comforting one-pot soup that keeps well for the week.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 35,
            difficulty: .easy,
            tags: ["vegan", "meal-prep", "high-protein"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (300, "g", pool.ingredient("Red lentils", category: .grain)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
                (2, "units", pool.ingredient("Carrot", category: .produce)),
                (1, "L", pool.ingredient("Vegetable broth", category: .other)),
            ],
            steps: lentilSoupSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeSalmonRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Pan-Seared Salmon",
            summary: "Golden salmon fillets with lemon and herbs.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 12,
            difficulty: .medium,
            tags: ["high-protein", "low-carbs", "no-carbs"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "pieces", pool.ingredient("Salmon fillet", category: .protein)),
                (1, "tbsp", pool.ingredient("Olive oil", category: .other)),
                (1, "units", pool.ingredient("Lemon", category: .produce)),
            ],
            steps: salmonSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeOvernightOatsRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Overnight Oats",
            summary: "No-cook oats with fruit — prep tonight, eat tomorrow.",
            servings: 1,
            prepMinutes: 10,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["vegan", "quick", "meal-prep", "breakfast"],
            cookingTools: cookingTools(.fridge)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (50, "g", pool.ingredient("Rolled oats", category: .grain)),
                (120, "g", pool.ingredient("Almond milk", category: .other)),
                (1, "tbsp", pool.ingredient("Chia seeds", category: .other)),
                (1, "units", pool.ingredient("Banana", category: .produce)),
            ],
            steps: overnightOatsSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeTomatoSoupRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Tomato Basil Soup",
            summary: "Smooth tomato soup with fresh basil.",
            servings: 4,
            prepMinutes: 10,
            cookMinutes: 25,
            difficulty: .easy,
            tags: ["vegetarian", "italian", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (800, "g", pool.ingredient("Tomatoes", category: .produce)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
                (2, "cups", pool.ingredient("Vegetable broth", category: .other)),
                (10, "g", pool.ingredient("Fresh basil", category: .produce)),
            ],
            steps: tomatoSoupSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeBananaNiceCreamRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Banana Nice Cream",
            summary: "Two-ingredient frozen banana soft serve.",
            servings: 2,
            prepMinutes: 5,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["dessert", "vegan", "quick"],
            cookingTools: cookingTools(.freezer)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (3, "units", pool.ingredient("Banana", category: .produce)),
                (2, "tbsp", pool.ingredient("Almond milk", category: .other)),
            ],
            steps: bananaNiceCreamSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func attach(
        recipe: Recipe,
        ingredients: [(Double, String, Ingredient)],
        steps: [RecipeStep],
        context: ModelContext
    ) {
        let recipeIngredients = ingredients.map { quantity, unit, ingredient in
            let item = RecipeIngredient(quantity: quantity, unit: unit, ingredient: ingredient, recipe: recipe)
            context.insert(item)
            return item
        }
        recipe.ingredients = recipeIngredients
        recipe.steps = steps
    }

    // MARK: - Steps

    private static func aglioOlioSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Boil salted water and cook spaghetti until al dente.", 600),
            ("Slice garlic thinly and gently sauté in olive oil until fragrant.", 180),
            ("Toss drained pasta with the garlic oil. Season and serve.", nil),
        ])
    }

    private static func chickenBowlSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cook brown rice according to package directions.", 1200),
            ("Season chicken and pan-sear until cooked through.", 480),
            ("Steam broccoli until tender-crisp.", 300),
            ("Slice chicken and assemble bowls with rice and broccoli.", nil),
        ])
    }

    private static func scrambledEggsSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Whisk eggs with milk, salt, and pepper.", nil),
            ("Melt butter in a pan over medium-low heat.", 60),
            ("Cook eggs slowly, stirring, until softly set.", 180),
        ])
    }

    private static func greekSaladSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Chop cucumber, tomatoes, and crumble feta.", nil),
            ("Whisk olive oil with lemon juice, salt, and oregano.", nil),
            ("Toss vegetables with dressing and serve immediately.", nil),
        ])
    }

    private static func lentilSoupSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Dice onion and carrot.", nil),
            ("Sauté vegetables until softened.", 300),
            ("Add lentils and broth. Simmer until tender.", 1500),
        ])
    }

    private static func salmonSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Pat salmon dry and season with salt and pepper.", nil),
            ("Sear skin-side down in hot oil until crisp.", 240),
            ("Flip and cook through. Finish with lemon.", 180),
        ])
    }

    private static func overnightOatsSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Combine oats, milk, and chia seeds in a jar.", nil),
            ("Refrigerate overnight.", nil),
            ("Top with sliced banana before serving.", nil),
        ])
    }

    private static func tomatoSoupSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Sauté chopped onion until soft.", 300),
            ("Add tomatoes and broth. Simmer for 20 minutes.", 1200),
            ("Blend until smooth and stir in fresh basil.", nil),
        ])
    }

    private static func bananaNiceCreamSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Peel and slice ripe bananas. Freeze until solid.", nil),
            ("Blend frozen banana with almond milk until creamy.", nil),
            ("Serve immediately or freeze briefly for a firmer texture.", nil),
        ])
    }

    private static func makeSteps(
        recipe: Recipe,
        context: ModelContext,
        steps: [(String, Int?)]
    ) -> [RecipeStep] {
        steps.enumerated().map { index, entry in
            let step = RecipeStep(
                order: index,
                instruction: entry.0,
                timerSeconds: entry.1,
                recipe: recipe
            )
            context.insert(step)
            return step
        }
    }
}
