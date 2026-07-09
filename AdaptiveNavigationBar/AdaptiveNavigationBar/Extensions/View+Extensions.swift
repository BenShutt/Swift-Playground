//
//  View+Extensions.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 07/11/2023.
//

import SwiftUI

extension View {
    func onSizeChanged(
        _ action: @escaping (CGSize) -> Void
    ) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: SizePreferenceKey.self,
                    value: proxy.size
                )
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { value in
            action(value)
        }
    }
}

// MARK: - SizePreferenceKey

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
