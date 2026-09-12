//  SampleDataSeeder+ExtendedRecipes.swift
//  CookGPT
//
//  Additional starter recipes for onboarding recipe packs.
//

import Foundation
import SwiftData

extension SampleDataSeeder {
    static func makeExtendedRecipe(
        id: SampleRecipeID,
        pool: inout IngredientPool,
        context: ModelContext
    ) -> Recipe? {
        switch id {
        case .chickpeaCurry:
            return makeChickpeaCurryRecipe(pool: &pool, context: context)
        case .veggieStirFry:
            return makeVeggieStirFryRecipe(pool: &pool, context: context)
        case .avocadoToast:
            return makeAvocadoToastRecipe(pool: &pool, context: context)
        case .capreseSalad:
            return makeCapreseSaladRecipe(pool: &pool, context: context)
        case .mushroomRisotto:
            return makeMushroomRisottoRecipe(pool: &pool, context: context)
        case .turkeyMeatballs:
            return makeTurkeyMeatballsRecipe(pool: &pool, context: context)
        case .eggWhiteOmelette:
            return makeEggWhiteOmeletteRecipe(pool: &pool, context: context)
        case .cobbSalad:
            return makeCobbSaladRecipe(pool: &pool, context: context)
        case .zucchiniNoodles:
            return makeZucchiniNoodlesRecipe(pool: &pool, context: context)
        case .grilledChicken:
            return makeGrilledChickenRecipe(pool: &pool, context: context)
        case .steakBites:
            return makeSteakBitesRecipe(pool: &pool, context: context)
        case .shrimpScampi:
            return makeShrimpScampiRecipe(pool: &pool, context: context)
        case .eggMuffins:
            return makeEggMuffinsRecipe(pool: &pool, context: context)
        case .tunaSalad:
            return makeTunaSaladRecipe(pool: &pool, context: context)
        case .steamedVeggies:
            return makeSteamedVeggiesRecipe(pool: &pool, context: context)
        case .berrySmoothieBowl:
            return makeBerrySmoothieBowlRecipe(pool: &pool, context: context)
        case .bakedCod:
            return makeBakedCodRecipe(pool: &pool, context: context)
        case .riceAndBeans:
            return makeRiceAndBeansRecipe(pool: &pool, context: context)
        case .cucumberSalad:
            return makeCucumberSaladRecipe(pool: &pool, context: context)
        case .margheritaFlatbread:
            return makeMargheritaFlatbreadRecipe(pool: &pool, context: context)
        case .pestoPasta:
            return makePestoPastaRecipe(pool: &pool, context: context)
        case .burritoBowl:
            return makeBurritoBowlRecipe(pool: &pool, context: context)
        case .quinoaSalad:
            return makeQuinoaSaladRecipe(pool: &pool, context: context)
        case .yogurtParfait:
            return makeYogurtParfaitRecipe(pool: &pool, context: context)
        case .chocolateMousse:
            return makeChocolateMousseRecipe(pool: &pool, context: context)
        case .appleCrumble:
            return makeAppleCrumbleRecipe(pool: &pool, context: context)
        case .chiaPudding:
            return makeChiaPuddingRecipe(pool: &pool, context: context)
        case .bakedPeaches:
            return makeBakedPeachesRecipe(pool: &pool, context: context)
        case .coconutCookies:
            return makeCoconutCookiesRecipe(pool: &pool, context: context)
        default:
            return nil
        }
    }

    static func rebuildExtendedRecipeSteps(recipe: Recipe, context: ModelContext) -> Bool {
        switch recipe.title {
        case "Chickpea Coconut Curry":
            recipe.steps = chickpeaCurrySteps(recipe: recipe, context: context)
        case "Rainbow Veggie Stir-Fry":
            recipe.steps = veggieStirFrySteps(recipe: recipe, context: context)
        case "Avocado Toast":
            recipe.steps = avocadoToastSteps(recipe: recipe, context: context)
        case "Caprese Salad":
            recipe.steps = capreseSaladSteps(recipe: recipe, context: context)
        case "Mushroom Risotto":
            recipe.steps = mushroomRisottoSteps(recipe: recipe, context: context)
        case "Turkey Meatballs":
            recipe.steps = turkeyMeatballsSteps(recipe: recipe, context: context)
        case "Egg White Omelette":
            recipe.steps = eggWhiteOmeletteSteps(recipe: recipe, context: context)
        case "Cobb Salad":
            recipe.steps = cobbSaladSteps(recipe: recipe, context: context)
        case "Zucchini Noodles with Marinara":
            recipe.steps = zucchiniNoodlesSteps(recipe: recipe, context: context)
        case "Grilled Lemon Chicken":
            recipe.steps = grilledChickenSteps(recipe: recipe, context: context)
        case "Garlic Steak Bites":
            recipe.steps = steakBitesSteps(recipe: recipe, context: context)
        case "Shrimp Scampi":
            recipe.steps = shrimpScampiSteps(recipe: recipe, context: context)
        case "Spinach Egg Muffins":
            recipe.steps = eggMuffinsSteps(recipe: recipe, context: context)
        case "Tuna Salad Bowl":
            recipe.steps = tunaSaladSteps(recipe: recipe, context: context)
        case "Steamed Veggie Medley":
            recipe.steps = steamedVeggiesSteps(recipe: recipe, context: context)
        case "Berry Smoothie Bowl":
            recipe.steps = berrySmoothieBowlSteps(recipe: recipe, context: context)
        case "Baked Cod with Herbs":
            recipe.steps = bakedCodSteps(recipe: recipe, context: context)
        case "Rice and Black Beans":
            recipe.steps = riceAndBeansSteps(recipe: recipe, context: context)
        case "Cucumber Dill Salad":
            recipe.steps = cucumberSaladSteps(recipe: recipe, context: context)
        case "Margherita Flatbread":
            recipe.steps = margheritaFlatbreadSteps(recipe: recipe, context: context)
        case "Pesto Pasta":
            recipe.steps = pestoPastaSteps(recipe: recipe, context: context)
        case "Chicken Burrito Bowl":
            recipe.steps = burritoBowlSteps(recipe: recipe, context: context)
        case "Quinoa Power Salad":
            recipe.steps = quinoaSaladSteps(recipe: recipe, context: context)
        case "Yogurt Berry Parfait":
            recipe.steps = yogurtParfaitSteps(recipe: recipe, context: context)
        case "Chocolate Avocado Mousse":
            recipe.steps = chocolateMousseSteps(recipe: recipe, context: context)
        case "Apple Cinnamon Crumble":
            recipe.steps = appleCrumbleSteps(recipe: recipe, context: context)
        case "Vanilla Chia Pudding":
            recipe.steps = chiaPuddingSteps(recipe: recipe, context: context)
        case "Baked Cinnamon Peaches":
            recipe.steps = bakedPeachesSteps(recipe: recipe, context: context)
        case "Coconut Almond Cookies":
            recipe.steps = coconutCookiesSteps(recipe: recipe, context: context)
        default:
            return false
        }
        return true
    }

    static func applyExtendedCookingTools(recipe: Recipe) -> Bool {
        switch recipe.title {
        case "Chickpea Coconut Curry", "Rainbow Veggie Stir-Fry", "Mushroom Risotto", "Turkey Meatballs",
             "Egg White Omelette", "Zucchini Noodles with Marinara", "Grilled Lemon Chicken", "Garlic Steak Bites",
             "Shrimp Scampi", "Spinach Egg Muffins", "Baked Cod with Herbs", "Rice and Black Beans",
             "Margherita Flatbread", "Pesto Pasta", "Chicken Burrito Bowl", "Apple Cinnamon Crumble",
             "Baked Cinnamon Peaches", "Coconut Almond Cookies":
            recipe.cookingTools = cookingTools(.pan)
        case "Avocado Toast", "Caprese Salad", "Cobb Salad", "Tuna Salad Bowl", "Steamed Veggie Medley",
             "Cucumber Dill Salad", "Quinoa Power Salad", "Yogurt Berry Parfait", "Chocolate Avocado Mousse":
            recipe.cookingTools = []
        case "Berry Smoothie Bowl", "Vanilla Chia Pudding":
            recipe.cookingTools = cookingTools(.fridge)
        default:
            return false
        }
        return true
    }

    // MARK: - Recipes

    private static func makeChickpeaCurryRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Chickpea Coconut Curry",
            summary: "Creamy one-pot curry with chickpeas and spinach.",
            servings: 4,
            prepMinutes: 10,
            cookMinutes: 20,
            difficulty: .easy,
            tags: ["vegan", "meal-prep", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "cans", pool.ingredient("Chickpeas", category: .protein)),
                (400, "ml", pool.ingredient("Coconut milk", category: .other)),
                (200, "g", pool.ingredient("Spinach", category: .produce)),
                (1, "units", pool.ingredient("Onion", category: .produce)),
            ],
            steps: chickpeaCurrySteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeVeggieStirFryRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Rainbow Veggie Stir-Fry",
            summary: "Colorful vegetables tossed in a ginger soy glaze.",
            servings: 3,
            prepMinutes: 15,
            cookMinutes: 10,
            difficulty: .easy,
            tags: ["vegan", "quick", "low-carbs"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "units", pool.ingredient("Bell pepper", category: .produce)),
                (200, "g", pool.ingredient("Broccoli", category: .produce)),
                (2, "tbsp", pool.ingredient("Soy sauce", category: .other)),
                (1, "tbsp", pool.ingredient("Ginger", category: .produce)),
            ],
            steps: veggieStirFrySteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeAvocadoToastRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Avocado Toast",
            summary: "Smashed avocado on toasted sourdough with chili flakes.",
            servings: 2,
            prepMinutes: 8,
            cookMinutes: 4,
            difficulty: .easy,
            tags: ["vegetarian", "breakfast", "quick"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "slices", pool.ingredient("Sourdough bread", category: .grain)),
                (2, "units", pool.ingredient("Avocado", category: .produce)),
                (1, "pinch", pool.ingredient("Chili flakes", category: .other)),
            ],
            steps: avocadoToastSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeCapreseSaladRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Caprese Salad",
            summary: "Tomatoes, mozzarella, and basil with balsamic.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["vegetarian", "italian", "quick", "low-carbs"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (3, "units", pool.ingredient("Tomato", category: .produce)),
                (200, "g", pool.ingredient("Mozzarella", category: .dairy)),
                (10, "g", pool.ingredient("Fresh basil", category: .produce)),
            ],
            steps: capreseSaladSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeMushroomRisottoRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Mushroom Risotto",
            summary: "Creamy arborio rice with sautéed mushrooms.",
            servings: 3,
            prepMinutes: 10,
            cookMinutes: 30,
            difficulty: .medium,
            tags: ["vegetarian", "italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (300, "g", pool.ingredient("Arborio rice", category: .grain)),
                (250, "g", pool.ingredient("Mushrooms", category: .produce)),
                (1, "L", pool.ingredient("Vegetable broth", category: .other)),
            ],
            steps: mushroomRisottoSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeTurkeyMeatballsRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Turkey Meatballs",
            summary: "Lean turkey meatballs in tomato sauce.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 20,
            difficulty: .medium,
            tags: ["high-protein", "meal-prep", "italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (500, "g", pool.ingredient("Ground turkey", category: .protein)),
                (400, "g", pool.ingredient("Tomatoes", category: .produce)),
                (1, "units", pool.ingredient("Egg", category: .protein)),
            ],
            steps: turkeyMeatballsSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeEggWhiteOmeletteRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Egg White Omelette",
            summary: "Light omelette with spinach and herbs.",
            servings: 1,
            prepMinutes: 5,
            cookMinutes: 6,
            difficulty: .easy,
            tags: ["high-protein", "breakfast", "quick", "low-carbs", "no-fats"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (4, "units", pool.ingredient("Egg whites", category: .protein)),
                (50, "g", pool.ingredient("Spinach", category: .produce)),
                (1, "pinch", pool.ingredient("Fresh herbs", category: .produce)),
            ],
            steps: eggWhiteOmeletteSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeCobbSaladRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Cobb Salad",
            summary: "Chicken, egg, avocado, and greens with ranch.",
            servings: 2,
            prepMinutes: 15,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["high-protein", "low-carbs", "no-carbs", "quick"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "cups", pool.ingredient("Mixed greens", category: .produce)),
                (1, "pieces", pool.ingredient("Chicken breast", category: .protein)),
                (2, "units", pool.ingredient("Eggs", category: .protein)),
                (1, "units", pool.ingredient("Avocado", category: .produce)),
            ],
            steps: cobbSaladSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeZucchiniNoodlesRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Zucchini Noodles with Marinara",
            summary: "Spiralized zucchini in a quick tomato sauce.",
            servings: 2,
            prepMinutes: 12,
            cookMinutes: 10,
            difficulty: .easy,
            tags: ["vegetarian", "low-carbs", "no-carbs", "quick", "italian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (3, "units", pool.ingredient("Zucchini", category: .produce)),
                (400, "g", pool.ingredient("Tomatoes", category: .produce)),
                (2, "cloves", pool.ingredient("Garlic", category: .produce)),
            ],
            steps: zucchiniNoodlesSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeGrilledChickenRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Grilled Lemon Chicken",
            summary: "Simple grilled chicken with lemon and herbs.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["high-protein", "low-carbs", "no-carbs", "meal-prep", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "pieces", pool.ingredient("Chicken breast", category: .protein)),
                (1, "units", pool.ingredient("Lemon", category: .produce)),
                (1, "tbsp", pool.ingredient("Olive oil", category: .other)),
            ],
            steps: grilledChickenSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeSteakBitesRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Garlic Steak Bites",
            summary: "Seared steak cubes with garlic butter.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 8,
            difficulty: .medium,
            tags: ["high-protein", "no-carbs", "low-carbs", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (400, "g", pool.ingredient("Steak", category: .protein)),
                (2, "tbsp", pool.ingredient("Butter", category: .dairy)),
                (3, "cloves", pool.ingredient("Garlic", category: .produce)),
            ],
            steps: steakBitesSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeShrimpScampiRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Shrimp Scampi",
            summary: "Garlicky shrimp with lemon and parsley.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 8,
            difficulty: .medium,
            tags: ["high-protein", "no-carbs", "low-carbs", "italian", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (300, "g", pool.ingredient("Shrimp", category: .protein)),
                (3, "cloves", pool.ingredient("Garlic", category: .produce)),
                (2, "tbsp", pool.ingredient("Butter", category: .dairy)),
            ],
            steps: shrimpScampiSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeEggMuffinsRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Spinach Egg Muffins",
            summary: "Bake-ahead egg cups with spinach and cheese.",
            servings: 6,
            prepMinutes: 10,
            cookMinutes: 20,
            difficulty: .easy,
            tags: ["high-protein", "breakfast", "meal-prep", "low-carbs", "no-carbs"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (6, "units", pool.ingredient("Eggs", category: .protein)),
                (100, "g", pool.ingredient("Spinach", category: .produce)),
                (50, "g", pool.ingredient("Cheddar cheese", category: .dairy)),
            ],
            steps: eggMuffinsSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeTunaSaladRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Tuna Salad Bowl",
            summary: "Protein-packed tuna over crisp greens.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["high-protein", "low-carbs", "no-carbs", "quick", "no-fats"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "cans", pool.ingredient("Tuna", category: .protein)),
                (2, "cups", pool.ingredient("Mixed greens", category: .produce)),
                (1, "units", pool.ingredient("Cucumber", category: .produce)),
            ],
            steps: tunaSaladSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeSteamedVeggiesRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Steamed Veggie Medley",
            summary: "Broccoli, carrots, and green beans steamed until tender.",
            servings: 3,
            prepMinutes: 8,
            cookMinutes: 10,
            difficulty: .easy,
            tags: ["vegan", "vegetarian", "no-fats", "low-carbs", "quick"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (200, "g", pool.ingredient("Broccoli", category: .produce)),
                (2, "units", pool.ingredient("Carrot", category: .produce)),
                (150, "g", pool.ingredient("Green beans", category: .produce)),
            ],
            steps: steamedVeggiesSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeBerrySmoothieBowlRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Berry Smoothie Bowl",
            summary: "Thick blended berries topped with granola.",
            servings: 1,
            prepMinutes: 8,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["vegan", "breakfast", "quick", "no-fats"],
            cookingTools: cookingTools(.fridge)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (200, "g", pool.ingredient("Mixed berries", category: .produce)),
                (1, "units", pool.ingredient("Banana", category: .produce)),
                (30, "g", pool.ingredient("Granola", category: .grain)),
            ],
            steps: berrySmoothieBowlSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeBakedCodRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Baked Cod with Herbs",
            summary: "Flaky cod baked with lemon and parsley.",
            servings: 2,
            prepMinutes: 8,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["high-protein", "no-fats", "low-carbs", "no-carbs"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "fillets", pool.ingredient("Cod", category: .protein)),
                (1, "units", pool.ingredient("Lemon", category: .produce)),
                (10, "g", pool.ingredient("Fresh herbs", category: .produce)),
            ],
            steps: bakedCodSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeRiceAndBeansRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Rice and Black Beans",
            summary: "Simple plant-based bowl with seasoned beans.",
            servings: 4,
            prepMinutes: 5,
            cookMinutes: 20,
            difficulty: .easy,
            tags: ["vegan", "vegetarian", "no-fats", "meal-prep"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "cups", pool.ingredient("Brown rice", category: .grain)),
                (2, "cans", pool.ingredient("Black beans", category: .protein)),
                (1, "tsp", pool.ingredient("Cumin", category: .other)),
            ],
            steps: riceAndBeansSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeCucumberSaladRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Cucumber Dill Salad",
            summary: "Cool cucumber salad with dill and vinegar.",
            servings: 3,
            prepMinutes: 10,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["vegan", "vegetarian", "no-fats", "quick", "low-carbs"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "units", pool.ingredient("Cucumber", category: .produce)),
                (2, "tbsp", pool.ingredient("Vinegar", category: .other)),
                (5, "g", pool.ingredient("Fresh dill", category: .produce)),
            ],
            steps: cucumberSaladSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeMargheritaFlatbreadRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Margherita Flatbread",
            summary: "Crispy flatbread with tomato, mozzarella, and basil.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 12,
            difficulty: .easy,
            tags: ["vegetarian", "italian", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "pieces", pool.ingredient("Flatbread", category: .grain)),
                (200, "g", pool.ingredient("Tomatoes", category: .produce)),
                (150, "g", pool.ingredient("Mozzarella", category: .dairy)),
            ],
            steps: margheritaFlatbreadSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makePestoPastaRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Pesto Pasta",
            summary: "Basil pesto tossed with al dente pasta.",
            servings: 3,
            prepMinutes: 8,
            cookMinutes: 12,
            difficulty: .easy,
            tags: ["vegetarian", "italian", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (250, "g", pool.ingredient("Pasta", category: .grain)),
                (3, "tbsp", pool.ingredient("Basil pesto", category: .other)),
                (20, "g", pool.ingredient("Parmesan", category: .dairy)),
            ],
            steps: pestoPastaSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeBurritoBowlRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Chicken Burrito Bowl",
            summary: "Rice, beans, chicken, and salsa in one bowl.",
            servings: 3,
            prepMinutes: 15,
            cookMinutes: 20,
            difficulty: .medium,
            tags: ["high-protein", "meal-prep"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "pieces", pool.ingredient("Chicken breast", category: .protein)),
                (2, "cups", pool.ingredient("Brown rice", category: .grain)),
                (1, "can", pool.ingredient("Black beans", category: .protein)),
            ],
            steps: burritoBowlSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeQuinoaSaladRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Quinoa Power Salad",
            summary: "Quinoa with chickpeas, cucumber, and lemon.",
            servings: 3,
            prepMinutes: 12,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["vegan", "meal-prep", "high-protein", "no-fats"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (200, "g", pool.ingredient("Quinoa", category: .grain)),
                (1, "can", pool.ingredient("Chickpeas", category: .protein)),
                (1, "units", pool.ingredient("Cucumber", category: .produce)),
            ],
            steps: quinoaSaladSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeYogurtParfaitRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Yogurt Berry Parfait",
            summary: "Layered yogurt, berries, and honey.",
            servings: 1,
            prepMinutes: 5,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["vegetarian", "breakfast", "quick", "high-protein"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (200, "g", pool.ingredient("Greek yogurt", category: .dairy)),
                (100, "g", pool.ingredient("Mixed berries", category: .produce)),
                (1, "tbsp", pool.ingredient("Honey", category: .other)),
            ],
            steps: yogurtParfaitSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeChocolateMousseRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Chocolate Avocado Mousse",
            summary: "Rich dairy-free chocolate mousse.",
            servings: 2,
            prepMinutes: 10,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["dessert", "vegan", "quick"],
            cookingTools: []
        )
        attach(
            recipe: recipe,
            ingredients: [
                (2, "units", pool.ingredient("Avocado", category: .produce)),
                (40, "g", pool.ingredient("Dark chocolate", category: .other)),
                (2, "tbsp", pool.ingredient("Maple syrup", category: .other)),
            ],
            steps: chocolateMousseSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeAppleCrumbleRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Apple Cinnamon Crumble",
            summary: "Baked apples with an oat crumble topping.",
            servings: 4,
            prepMinutes: 15,
            cookMinutes: 30,
            difficulty: .easy,
            tags: ["dessert", "vegetarian"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (4, "units", pool.ingredient("Apple", category: .produce)),
                (80, "g", pool.ingredient("Rolled oats", category: .grain)),
                (1, "tsp", pool.ingredient("Cinnamon", category: .other)),
            ],
            steps: appleCrumbleSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeChiaPuddingRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Vanilla Chia Pudding",
            summary: "Creamy make-ahead chia pudding.",
            servings: 2,
            prepMinutes: 8,
            cookMinutes: 0,
            difficulty: .easy,
            tags: ["dessert", "vegan", "breakfast", "meal-prep"],
            cookingTools: cookingTools(.fridge)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (4, "tbsp", pool.ingredient("Chia seeds", category: .other)),
                (300, "ml", pool.ingredient("Almond milk", category: .other)),
                (1, "tsp", pool.ingredient("Vanilla extract", category: .other)),
            ],
            steps: chiaPuddingSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeBakedPeachesRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Baked Cinnamon Peaches",
            summary: "Warm peaches with cinnamon and oats.",
            servings: 2,
            prepMinutes: 8,
            cookMinutes: 20,
            difficulty: .easy,
            tags: ["dessert", "vegetarian", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (3, "units", pool.ingredient("Peach", category: .produce)),
                (2, "tbsp", pool.ingredient("Rolled oats", category: .grain)),
                (1, "tsp", pool.ingredient("Cinnamon", category: .other)),
            ],
            steps: bakedPeachesSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    private static func makeCoconutCookiesRecipe(pool: inout IngredientPool, context: ModelContext) -> Recipe {
        let recipe = Recipe(
            title: "Coconut Almond Cookies",
            summary: "Chewy cookies with coconut and almonds.",
            servings: 12,
            prepMinutes: 12,
            cookMinutes: 15,
            difficulty: .easy,
            tags: ["dessert", "vegetarian", "quick"],
            cookingTools: cookingTools(.pan)
        )
        attach(
            recipe: recipe,
            ingredients: [
                (100, "g", pool.ingredient("Shredded coconut", category: .other)),
                (80, "g", pool.ingredient("Almond flour", category: .grain)),
                (2, "units", pool.ingredient("Eggs", category: .protein)),
            ],
            steps: coconutCookiesSteps(recipe: recipe, context: context),
            context: context
        )
        return recipe
    }

    // MARK: - Steps

    private static func chickpeaCurrySteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Dice onion and sauté until soft.", 240),
            ("Add chickpeas, coconut milk, and spinach. Simmer.", 900),
            ("Season and serve with rice or flatbread.", nil),
        ])
    }

    private static func veggieStirFrySteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Slice peppers and broccoli.", nil),
            ("Stir-fry vegetables over high heat.", 360),
            ("Add soy sauce and ginger. Toss to coat.", 120),
        ])
    }

    private static func avocadoToastSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Toast bread until golden.", 240),
            ("Mash avocado with salt and chili flakes.", nil),
            ("Spread on toast and serve.", nil),
        ])
    }

    private static func capreseSaladSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Slice tomatoes and mozzarella.", nil),
            ("Arrange with basil leaves.", nil),
            ("Drizzle with balsamic and olive oil.", nil),
        ])
    }

    private static func mushroomRisottoSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Sauté sliced mushrooms.", 300),
            ("Toast rice and add warm broth gradually.", 1200),
            ("Stir until creamy and finish with parmesan.", nil),
        ])
    }

    private static func turkeyMeatballsSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Mix turkey, egg, and seasonings. Form meatballs.", nil),
            ("Brown meatballs in a pan.", 480),
            ("Simmer in tomato sauce until cooked through.", 600),
        ])
    }

    private static func eggWhiteOmeletteSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Whisk egg whites with herbs.", nil),
            ("Cook in a nonstick pan over medium heat.", 180),
            ("Add spinach, fold, and serve.", nil),
        ])
    }

    private static func cobbSaladSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cook chicken and hard-boil eggs.", 600),
            ("Chop avocado and arrange greens.", nil),
            ("Top with chicken, egg, and dressing.", nil),
        ])
    }

    private static func zucchiniNoodlesSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Spiralize zucchini into noodles.", nil),
            ("Simmer garlic and tomatoes into sauce.", 480),
            ("Toss zucchini noodles with warm sauce.", 180),
        ])
    }

    private static func grilledChickenSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Marinate chicken with lemon and herbs.", nil),
            ("Grill or pan-sear until cooked through.", 540),
            ("Rest briefly and slice.", 180),
        ])
    }

    private static func steakBitesSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cut steak into bite-size cubes.", nil),
            ("Sear in a hot pan.", 240),
            ("Add garlic butter and toss to coat.", 60),
        ])
    }

    private static func shrimpScampiSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Pat shrimp dry and season.", nil),
            ("Sauté garlic in butter.", 60),
            ("Cook shrimp until pink. Finish with lemon.", 240),
        ])
    }

    private static func eggMuffinsSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Whisk eggs with spinach and cheese.", nil),
            ("Divide into a greased muffin tin.", nil),
            ("Bake until set.", 1200),
        ])
    }

    private static func tunaSaladSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Drain tuna and flake into a bowl.", nil),
            ("Chop cucumber and greens.", nil),
            ("Assemble bowls and serve.", nil),
        ])
    }

    private static func steamedVeggiesSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Trim and chop vegetables.", nil),
            ("Steam until tender-crisp.", 480),
            ("Season and serve warm.", nil),
        ])
    }

    private static func berrySmoothieBowlSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Blend berries and banana until thick.", nil),
            ("Pour into a bowl.", nil),
            ("Top with granola and serve.", nil),
        ])
    }

    private static func bakedCodSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Season cod with herbs and lemon.", nil),
            ("Bake until flaky.", 900),
            ("Serve immediately.", nil),
        ])
    }

    private static func riceAndBeansSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cook rice according to package directions.", 1200),
            ("Warm beans with cumin.", 300),
            ("Combine and serve.", nil),
        ])
    }

    private static func cucumberSaladSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Slice cucumber thinly.", nil),
            ("Toss with vinegar and dill.", nil),
            ("Chill briefly before serving.", 600),
        ])
    }

    private static func margheritaFlatbreadSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Top flatbread with tomato and mozzarella.", nil),
            ("Bake or pan-toast until cheese melts.", 720),
            ("Finish with fresh basil.", nil),
        ])
    }

    private static func pestoPastaSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Boil pasta until al dente.", 600),
            ("Reserve a little pasta water.", nil),
            ("Toss pasta with pesto and parmesan.", nil),
        ])
    }

    private static func burritoBowlSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cook rice and warm beans.", 1200),
            ("Season and cook chicken.", 480),
            ("Assemble bowls with salsa.", nil),
        ])
    }

    private static func quinoaSaladSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Cook quinoa until fluffy.", 900),
            ("Dice cucumber and rinse chickpeas.", nil),
            ("Toss with lemon dressing.", nil),
        ])
    }

    private static func yogurtParfaitSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Layer yogurt and berries in a glass.", nil),
            ("Drizzle with honey.", nil),
            ("Serve immediately.", nil),
        ])
    }

    private static func chocolateMousseSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Blend avocado, melted chocolate, and maple syrup.", nil),
            ("Chill until set.", 1800),
            ("Serve chilled.", nil),
        ])
    }

    private static func appleCrumbleSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Slice apples and toss with cinnamon.", nil),
            ("Mix oat crumble topping.", nil),
            ("Bake until golden.", 1800),
        ])
    }

    private static func chiaPuddingSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Whisk chia seeds, milk, and vanilla.", nil),
            ("Refrigerate until thickened.", nil),
            ("Top and serve.", nil),
        ])
    }

    private static func bakedPeachesSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Halve peaches and sprinkle with cinnamon.", nil),
            ("Top with oats.", nil),
            ("Bake until tender.", 1200),
        ])
    }

    private static func coconutCookiesSteps(recipe: Recipe, context: ModelContext) -> [RecipeStep] {
        makeSteps(recipe: recipe, context: context, steps: [
            ("Mix coconut, almond flour, and eggs.", nil),
            ("Shape into cookies.", nil),
            ("Bake until golden.", 900),
        ])
    }
}
