//  MeasurementSystem.swift
//  CookGPT
//
//  Metric vs imperial units for ingredients and groceries.
//

import Foundation

enum MeasurementSystem: String, CaseIterable, Identifiable, Codable {
    case metric
    case imperial

    var id: String { rawValue }

    var label: String {
        switch self {
        case .metric: "Metric"
        case .imperial: "Imperial"
        }
    }

    var units: [String] {
        switch self {
        case .metric:
            ["g", "mg", "ml", "L", "tbsp", "tsp", "cup", "pieces", "units"]
        case .imperial:
            ["oz", "lb", "fl oz", "cup", "tbsp", "tsp", "pieces", "units"]
        }
    }

    var defaultUnit: String {
        "units"
    }

    static var preferredForCurrentLocale: MeasurementSystem {
        switch Locale.current.measurementSystem {
        case .metric, .uk:
            return .metric
        case .us:
            return .imperial
        default:
            return .metric
        }
    }
}
