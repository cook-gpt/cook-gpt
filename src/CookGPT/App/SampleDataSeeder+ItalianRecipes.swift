//  SampleDataSeeder+ItalianRecipes.swift
//  CookGPT
//
//  Italian starter recipes for onboarding recipe packs.
//

import Foundation
import SwiftData

extension SampleDataSeeder {
    static func makeItalianRecipe(
        id: SampleRecipeID,
        pool: inout IngredientPool,
        context: ModelContext
    ) -> Recipe? {
        switch id {
        case .raguBolognese:
            return makeRaguBologneseRecipe(pool: &pool, context: context)
        case .onionFocaccia:
            return makeOnionFocacciaRecipe(pool: &pool, context: context)
        case .shrimpZucchiniRisotto:
            return makeShrimpZucchiniRisottoRecipe(pool: &pool, context: context)
        case .carbonara:
            return makeCarbonaraRecipe(pool: &pool, context: context)
        case .bruschetta:
            return makeBruschettaRecipe(pool: &pool, context: context)
        default:
            return nil
        }
    }

    // MARK: - Recipes

    static func makeRaguBologneseRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .raguBolognese,
            title: "Ragù Bolognese",
            summary: "Slow-simmered meat sauce with soffritto served over pasta.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 75,
            difficulty: .medium,
            tags: ["italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (400, "g", pool.ingredient("Ground beef", category: .protein)),
                (400, "g", pool.ingredient("Pasta", category: .grain)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
                (1, "units", pool.ingredient("Carrot", category: .produce)),
                (2, "units", pool.ingredient("Celery", category: .produce)),
                (400, "g", pool.ingredient("Tomatoes", category: .produce)),
                (2, "units", pool.ingredient("Garlic cloves", category: .produce)),
                (2, "tbsp", pool.ingredient("Olive oil", category: .other)),
                (500, "ml", pool.ingredient("Vegetable broth", category: .other)),
                (30, "g", pool.ingredient("Parmesan", category: .dairy)),
            ],
            steps: raguBologneseSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeOnionFocacciaRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .onionFocaccia,
            title: "Onion Focaccia",
            summary: "Soft oven-baked focaccia topped with sweet onions and olive oil.",
            servings: 6,
            prepMinutes: 20,
            cookMinutes: 25,
            difficulty: .medium,
            tags: ["italian", "vegetarian"],
            cookingTools: cookingTools(.oven)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (500, "g", pool.ingredient("All-purpose flour", category: .grain)),
                (300, "ml", pool.ingredient("Water", category: .other)),
                (7, "g", pool.ingredient("Dry yeast", category: .other)),
                (3, "units", pool.ingredient("Onion", category: .produce)),
                (4, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: onionFocacciaSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeShrimpZucchiniRisottoRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .shrimpZucchiniRisotto,
            title: "Shrimp and Zucchini Risotto",
            summary: "Creamy risotto with shrimp, zucchini, and parmesan.",
            servings: 3,
            prepMinutes: 10,
            cookMinutes: 30,
            difficulty: .medium,
            tags: ["italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (300, "g", pool.ingredient("Arborio rice", category: .grain)),
                (250, "g", pool.ingredient("Shrimp", category: .protein)),
                (2, "units", pool.ingredient("Zucchini", category: .produce)),
                (1, "L", pool.ingredient("Vegetable broth", category: .other)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
                (30, "g", pool.ingredient("Parmesan", category: .dairy)),
                (2, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: shrimpZucchiniRisottoSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeCarbonaraRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .carbonara,
            title: "Pasta Carbonara",
            summary: "Classic Roman pasta with eggs, pancetta, pecorino, and black pepper.",
            servings: 3,
            prepMinutes: 10,
            cookMinutes: 15,
            difficulty: .medium,
            tags: ["italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (300, "g", pool.ingredient("Spaghetti", category: .grain)),
                (150, "g", pool.ingredient("Pancetta", category: .protein)),
                (3, "units", pool.ingredient("Eggs", category: .protein)),
                (80, "g", pool.ingredient("Pecorino", category: .dairy)),
                (1, "tsp", pool.ingredient("Black pepper", category: .other)),
                (2, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: carbonaraSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeBruschettaRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .bruschetta,
            title: "Bruschetta",
            summary: "Toasted bread with fresh tomato, basil, and olive oil.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 5,
            difficulty: .easy,
            tags: ["italian", "breakfast", "vegetarian", "quick"],
            cookingTools: cookingTools(.oven)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (8, "slices", pool.ingredient("Sourdough bread", category: .grain)),
                (400, "g", pool.ingredient("Tomatoes", category: .produce)),
                (2, "units", pool.ingredient("Garlic cloves", category: .produce)),
                (3, "tbsp", pool.ingredient("Olive oil", category: .other)),
                (10, "g", pool.ingredient("Fresh basil", category: .produce)),
            ],
            steps: bruschettaSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    // MARK: - Steps

    static func raguBologneseSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Finely dice onion, carrot, and celery. Mince the garlic.", nil),
            ("Brown ground beef in olive oil. Add vegetables and cook until softened.", 600),
            ("Add tomatoes and broth. Simmer until thick, about 45 minutes.", 2700),
            ("Cook pasta, toss with ragù, and serve with parmesan.", 720),
        ])
    }

    static func onionFocacciaSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Dissolve yeast in warm water. Mix flour, water, yeast, and olive oil into a dough.", nil),
            ("Let dough rise until doubled in size.", 3600),
            ("Press dough into an oiled pan. Top with sliced onions and olive oil.", nil),
            ("Bake at 220°C until golden, about 25 minutes.", 1500),
        ])
    }

    static func shrimpZucchiniRisottoSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Dice zucchini and finely chop onion.", nil),
            ("Sauté onion in olive oil, then add rice and toast briefly.", 180),
            ("Add broth gradually, stirring, until rice is creamy and almost tender.", 1200),
            ("Stir in shrimp, zucchini, and parmesan. Cook until shrimp are pink.", 300),
        ])
    }

    static func carbonaraSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cook spaghetti in salted boiling water until al dente.", 600),
            ("Crisp pancetta in olive oil until golden.", 300),
            ("Whisk eggs with grated pecorino and black pepper.", nil),
            ("Toss hot pasta with pancetta, then quickly mix in the egg mixture off the heat.", nil),
        ])
    }

    static func bruschettaSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Dice tomatoes and toss with olive oil, basil, and salt.", nil),
            ("Toast bread slices until crisp.", 300),
            ("Rub warm bread lightly with garlic.", nil),
            ("Top with tomato mixture and serve.", nil),
        ])
    }
}
