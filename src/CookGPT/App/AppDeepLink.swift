//  AppDeepLink.swift
//  CookGPT
//
//  Custom URL scheme for Live Activity and notification deep links.
//

import Foundation

enum AppDeepLink {
    static let scheme = "cookgpt"

    struct RecipeDestination: Equatable {
        let recipeID: UUID
        let stepID: UUID?
    }

    static func recipeURL(id: UUID, stepID: UUID? = nil) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = "recipe"
        components.path = "/\(id.uuidString)"
        if let stepID {
            components.queryItems = [URLQueryItem(name: "step", value: stepID.uuidString)]
        }
        return components.url!
    }

    static func recipeDestination(from url: URL) -> RecipeDestination? {
        guard url.scheme == scheme, url.host == "recipe" else { return nil }
        let recipeIDString = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let recipeID = UUID(uuidString: recipeIDString) else { return nil }
        let stepID = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first(where: { $0.name == "step" })?
            .value
            .flatMap(UUID.init(uuidString:))
        return RecipeDestination(recipeID: recipeID, stepID: stepID)
    }
}
