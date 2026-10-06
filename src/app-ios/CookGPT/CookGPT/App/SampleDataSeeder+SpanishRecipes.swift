//  SampleDataSeeder+SpanishRecipes.swift
//  CookGPT
//
//  Spanish starter recipes for onboarding recipe packs.
//

import Foundation
import SwiftData

extension SampleDataSeeder {
    static func makeSpanishRecipe(
        id: SampleRecipeID,
        pool: inout IngredientPool,
        context: ModelContext
    ) -> Recipe? {
        switch id {
        case .paella:
            return makePaellaRecipe(pool: &pool, context: context)
        case .sopaDeAjo:
            return makeSopaDeAjoRecipe(pool: &pool, context: context)
        case .tortillaDePatatas:
            return makeTortillaDePatatasRecipe(pool: &pool, context: context)
        case .gazpacho:
            return makeGazpachoRecipe(pool: &pool, context: context)
        case .fabadaAsturiana:
            return makeFabadaAsturianaRecipe(pool: &pool, context: context)
        case .torrijas:
            return makeTorrijasRecipe(pool: &pool, context: context)
        default:
            return nil
        }
    }

    // MARK: - Recipes

    static func makePaellaRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .paella,
            title: "Seafood Paella",
            summary: "Catalan-style seafood paella with bomba rice, shellfish, and picada.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 28,
            difficulty: .medium,
            tags: ["spanish"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: seafoodPaellaIngredients(pool: &pool),
            steps: paellaSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func seafoodPaellaIngredients(
        pool: inout IngredientPool
    ) -> [(Double, String, Ingredient)] {
        [
            (320, "g", pool.ingredient("Bomba rice", category: .grain)),
            (1100, "ml", pool.ingredient("Fish stock", category: .other)),
            (300, "g", pool.ingredient("Cuttlefish", category: .protein)),
            (8, "units", pool.ingredient("Large shrimp", category: .protein)),
            (400, "g", pool.ingredient("Mussels and clams", category: .protein)),
            (1, "units", pool.ingredient("Onion", category: .produce)),
            (2, "units", pool.ingredient("Tomatoes", category: .produce)),
            (2, "units", pool.ingredient("Garlic cloves", category: .produce)),
            (3, "tbsp", pool.ingredient("Olive oil", category: .other)),
            (4, "sprigs", pool.ingredient("Parsley", category: .produce)),
            (1, "units", pool.ingredient("Toasted almond", category: .other)),
        ]
    }

    static func makeSopaDeAjoRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .sopaDeAjo,
            title: "Garlic Soup",
            summary: "Spanish sopa de ajo with bread, paprika, and poached egg.",
            servings: 3,
            prepMinutes: 10,
            cookMinutes: 20,
            difficulty: .easy,
            tags: ["spanish", "vegetarian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (8, "units", pool.ingredient("Garlic cloves", category: .produce)),
                (4, "slices", pool.ingredient("Sourdough bread", category: .grain)),
                (3, "tbsp", pool.ingredient("Olive oil", category: .other)),
                (1, "tsp", pool.ingredient("Smoked paprika", category: .other)),
                (1, "L", pool.ingredient("Vegetable broth", category: .other)),
                (3, "units", pool.ingredient("Eggs", category: .protein)),
            ],
            steps: sopaDeAjoSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeTortillaDePatatasRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .tortillaDePatatas,
            title: "Potato Omelette",
            summary: "Classic tortilla de patatas with potato and onion.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 25,
            difficulty: .medium,
            tags: ["spanish", "vegetarian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (500, "g", pool.ingredient("Potatoes", category: .produce)),
                (6, "units", pool.ingredient("Eggs", category: .protein)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
                (100, "ml", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: tortillaDePatatasSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeGazpachoRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .gazpacho,
            title: "Gazpacho",
            summary: "Chilled Spanish tomato and vegetable soup.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["spanish", "vegetarian", "vegan", "quick", "low-carbs"],
            cookingTools: cookingTools(.fridge)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (600, "g", pool.ingredient("Tomatoes", category: .produce)),
                (1, "units", pool.ingredient("Cucumber", category: .produce)),
                (1, "units", pool.ingredient("Bell pepper", category: .produce)),
                (2, "units", pool.ingredient("Garlic cloves", category: .produce)),
                (4, "tbsp", pool.ingredient("Olive oil", category: .other)),
                (2, "tbsp", pool.ingredient("Vinegar", category: .other)),
            ],
            steps: gazpachoSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeFabadaAsturianaRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .fabadaAsturiana,
            title: "Asturian Bean Stew",
            summary: "Hearty fabada with white beans and chorizo.",
            servings: 4,
            prepMinutes: 10,
            cookMinutes: 45,
            difficulty: .medium,
            tags: ["spanish"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (400, "g", pool.ingredient("White beans", category: .other)),
                (200, "g", pool.ingredient("Chorizo", category: .protein)),
                (1, "tsp", pool.ingredient("Smoked paprika", category: .other)),
                (3, "units", pool.ingredient("Garlic cloves", category: .produce)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
                (1, "L", pool.ingredient("Vegetable broth", category: .other)),
            ],
            steps: fabadaAsturianaSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    static func makeTorrijasRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = makeSampleRecipe(
            id: .torrijas,
            title: "Torrijas",
            summary: "Spanish-style milk toast with cinnamon and honey.",
            servings: 4,
            prepMinutes: 10,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["spanish", "dessert"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (8, "slices", pool.ingredient("Sourdough bread", category: .grain)),
                (300, "ml", pool.ingredient("Milk", category: .dairy)),
                (3, "units", pool.ingredient("Eggs", category: .protein)),
                (1, "tsp", pool.ingredient("Cinnamon", category: .other)),
                (3, "tbsp", pool.ingredient("Honey", category: .other)),
                (3, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: torrijasSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    // MARK: - Steps

    static func paellaSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Sear prawns in olive oil for about 1 minute per side. Remove and set aside.", 120),
            ("Sauté cuttlefish in the same pan until lightly browned and the liquid cooks off.", 300),
            ("Slowly sauté onion until tender and golden. Add garlic, then grated tomato, and cook until concentrated.", 600),
            ("Stir bomba rice into the sofrito for 1–2 minutes to toast.", 120),
            ("Pour in boiling fish stock. Add mussels, clams, and reserved cuttlefish.", nil),
            ("Cook on high heat for 8 minutes, then low for 8 minutes. Stir in picada (parsley, garlic, almond) mixed with broth midway.", 960),
            ("Top with reserved prawns in the final minutes. Rest covered for 5 minutes before serving.", 300),
        ])
    }

    static func sopaDeAjoSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Slice bread and toast until golden.", 240),
            ("Gently sauté sliced garlic in olive oil with smoked paprika.", 180),
            ("Add broth and simmer with bread until softened.", 600),
            ("Poach eggs in the soup and serve.", 300),
        ])
    }

    static func tortillaDePatatasSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Slowly fry sliced potato and onion in olive oil until tender.", 900),
            ("Beat eggs and season.", nil),
            ("Mix potatoes with eggs and cook in a pan until nearly set.", 480),
            ("Flip or cover and finish cooking, then serve warm.", 300),
        ])
    }

    static func gazpachoSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Roughly chop tomatoes, cucumber, and pepper.", nil),
            ("Blend with garlic, olive oil, and vinegar until smooth.", nil),
            ("Chill if desired and serve.", 1800),
        ])
    }

    static func fabadaAsturianaSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Rinse beans and simmer with onion, garlic, and smoked paprika.", 1200),
            ("Add chorizo and broth, then cook until creamy.", 1200),
            ("Rest briefly and serve.", 300),
        ])
    }

    static func torrijasSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Warm milk with cinnamon and soak bread slices.", 300),
            ("Dip soaked bread in beaten egg.", nil),
            ("Pan-fry in olive oil until golden.", 360),
            ("Dust with cinnamon and drizzle with honey.", nil),
        ])
    }
}
