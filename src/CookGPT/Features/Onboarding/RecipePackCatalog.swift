//  RecipePackCatalog.swift
//  CookGPT
//
//  Starter recipe collections shown during first-launch onboarding.
//

import Foundation

enum SampleRecipeID: String, CaseIterable, Hashable {
    case aglioOlio
    case chickenBowl
    case scrambledEggs
    case greekSalad
    case lentilSoup
    case salmon
    case overnightOats
    case tomatoSoup
    case bananaNiceCream
    case chickpeaCurry
    case veggieStirFry
    case avocadoToast
    case capreseSalad
    case mushroomRisotto
    case turkeyMeatballs
    case eggWhiteOmelette
    case cobbSalad
    case zucchiniNoodles
    case grilledChicken
    case steakBites
    case shrimpScampi
    case eggMuffins
    case tunaSalad
    case steamedVeggies
    case berrySmoothieBowl
    case bakedCod
    case riceAndBeans
    case cucumberSalad
    case margheritaFlatbread
    case pestoPasta
    case burritoBowl
    case quinoaSalad
    case yogurtParfait
    case chocolateMousse
    case appleCrumble
    case chiaPudding
    case bakedPeaches
    case coconutCookies
    case paella
    case sopaDeAjo
    case tortillaDePatatas
    case gazpacho
    case fabadaAsturiana
    case torrijas
    case raguBolognese
    case onionFocaccia
    case shrimpZucchiniRisotto
    case carbonara
    case bruschetta
}

struct RecipePackDefinition: Identifiable, Hashable {
    let categoryID: String
    let label: String
    let summary: String
    let systemImage: String
    let recipeIDs: [SampleRecipeID]

    var id: String { categoryID }

    var recipeCount: Int { recipeIDs.count }

    var localizedLabel: String {
        String(localized: String.LocalizationValue(label))
    }

    var localizedSummary: String {
        String(localized: String.LocalizationValue(summary))
    }
}

enum RecipePackCatalog {
    static let packs: [RecipePackDefinition] = [
        RecipePackDefinition(
            categoryID: "vegan",
            label: "Vegan",
            summary: "Plant-based soups, breakfasts, and desserts.",
            systemImage: "leaf.fill",
            recipeIDs: [.lentilSoup, .overnightOats, .bananaNiceCream, .chickpeaCurry, .veggieStirFry, .riceAndBeans]
        ),
        RecipePackDefinition(
            categoryID: "vegetarian",
            label: "Vegetarian",
            summary: "Meat-free pastas, salads, eggs, and soups.",
            systemImage: "carrot.fill",
            recipeIDs: [.aglioOlio, .scrambledEggs, .greekSalad, .tomatoSoup, .capreseSalad, .mushroomRisotto]
        ),
        RecipePackDefinition(
            categoryID: "high-protein",
            label: "High protein",
            summary: "Bowls, eggs, salmon, and hearty mains.",
            systemImage: "dumbbell.fill",
            recipeIDs: [.chickenBowl, .scrambledEggs, .lentilSoup, .salmon, .turkeyMeatballs, .grilledChicken]
        ),
        RecipePackDefinition(
            categoryID: "low-carbs",
            label: "Low carbs",
            summary: "Lighter salads and seared salmon.",
            systemImage: "chart.line.downtrend.xyaxis",
            recipeIDs: [.greekSalad, .salmon, .cobbSalad, .zucchiniNoodles, .tunaSalad, .grilledChicken]
        ),
        RecipePackDefinition(
            categoryID: "no-carbs",
            label: "No carbs",
            summary: "Simple salmon with lemon and herbs.",
            systemImage: "circle.slash",
            recipeIDs: [.salmon, .cobbSalad, .zucchiniNoodles, .grilledChicken, .steakBites, .shrimpScampi]
        ),
        RecipePackDefinition(
            categoryID: "no-fats",
            label: "No fats",
            summary: "Fresh Greek salad with lemon dressing.",
            systemImage: "circle.slash",
            recipeIDs: [.greekSalad, .steamedVeggies, .tunaSalad, .bakedCod, .cucumberSalad, .eggWhiteOmelette]
        ),
        RecipePackDefinition(
            categoryID: "italian",
            label: "Italian",
            summary: "Bolognese, focaccia, risotto, carbonara, and classic Italian dishes.",
            systemImage: "fork.knife",
            recipeIDs: [.raguBolognese, .onionFocaccia, .shrimpZucchiniRisotto, .carbonara, .aglioOlio, .bruschetta]
        ),
        RecipePackDefinition(
            categoryID: "spanish",
            label: "Spanish",
            summary: "Paella, gazpacho, tortilla, fabada, and classic Spanish dishes.",
            systemImage: "fork.knife",
            recipeIDs: [.paella, .sopaDeAjo, .tortillaDePatatas, .gazpacho, .fabadaAsturiana, .torrijas]
        ),
        RecipePackDefinition(
            categoryID: "breakfast",
            label: "Breakfast",
            summary: "Eggs and overnight oats to start the day.",
            systemImage: "sun.horizon.fill",
            recipeIDs: [.scrambledEggs, .overnightOats, .avocadoToast, .eggMuffins, .yogurtParfait, .berrySmoothieBowl]
        ),
        RecipePackDefinition(
            categoryID: "dessert",
            label: "Dessert",
            summary: "Frozen banana soft serve.",
            systemImage: "birthday.cake.fill",
            recipeIDs: [.bananaNiceCream, .chocolateMousse, .appleCrumble, .chiaPudding, .bakedPeaches, .coconutCookies]
        ),
    ]

    static func pack(for categoryID: String) -> RecipePackDefinition? {
        packs.first { $0.categoryID == categoryID }
    }

    static func recipeIDs(for categoryIDs: [String]) -> [SampleRecipeID] {
        var seen = Set<SampleRecipeID>()
        var ordered: [SampleRecipeID] = []

        for categoryID in categoryIDs {
            guard let pack = pack(for: categoryID) else { continue }
            for recipeID in pack.recipeIDs where seen.insert(recipeID).inserted {
                ordered.append(recipeID)
            }
        }

        return ordered
    }
}
