//  QuantityFormatter.swift
//  Cook GPT
//
//  Display formatting for ingredient and grocery quantities.
//

import Foundation

/// Formats ingredient and grocery quantities for display (whole numbers without decimals).
enum QuantityFormatter {
    static func string(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.1f", value)
    }
}
