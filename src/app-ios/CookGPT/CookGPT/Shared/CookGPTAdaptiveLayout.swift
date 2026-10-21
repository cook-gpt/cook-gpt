//  CookGPTAdaptiveLayout.swift
//  CookGPT
//
//  iPhone Duo / resizable layouts: avoid the active fold and prefer split navigation on wide width.
//

import SwiftUI

enum CookGPTAdaptiveLayout {
    /// Padding that keeps scrollable content out of an active Duo division (partial fold).
    static func divisionSafeEdgeInsets(in proxy: GeometryProxy) -> EdgeInsets {
        if #available(iOS 27.1, *) {
            return divisionSafeEdgeInsetsWhenFoldActive(in: proxy)
        }
        return EdgeInsets()
    }

    @available(iOS 27.1, *)
    private static func divisionSafeEdgeInsetsWhenFoldActive(in proxy: GeometryProxy) -> EdgeInsets {
        guard let division = proxy.reservedRegions(kind: .division).first else {
            return EdgeInsets()
        }

        let frame = division.frame
        if frame.height > frame.width {
            let gap = max(frame.width, 1)
            return EdgeInsets(top: 0, leading: gap / 2, bottom: 0, trailing: gap / 2)
        }

        let gap = max(frame.height, 1)
        return EdgeInsets(top: gap / 2, leading: 0, bottom: gap / 2, trailing: 0)
    }
}

private struct DivisionSafeAreaLayout: ViewModifier {
    @State private var divisionInsets = EdgeInsets()

    func body(content: Content) -> some View {
        content
            .safeAreaPadding(divisionInsets)
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            divisionInsets = CookGPTAdaptiveLayout.divisionSafeEdgeInsets(in: proxy)
                        }
                        .onChange(of: proxy.size) { _, _ in
                            divisionInsets = CookGPTAdaptiveLayout.divisionSafeEdgeInsets(in: proxy)
                        }
                }
            }
    }
}

extension View {
    /// Insets content away from an active iPhone Duo fold when the device is partially open.
    func cookGPTDivisionSafeContent() -> some View {
        modifier(DivisionSafeAreaLayout())
    }
}
