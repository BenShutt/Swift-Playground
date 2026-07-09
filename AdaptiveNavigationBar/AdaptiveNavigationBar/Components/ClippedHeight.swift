//
//  ClippedHeight.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 26/11/2023.
//

import SwiftUI

/// Clips a view (with a fixed vertical size) by the height mapping
private struct ClippedHeight: ViewModifier {

    /// The height of the content
    @State private var height: CGFloat = 0

    /// Map the content height to the clipped height (by scaling)
    var clippedHeight: (CGFloat) -> CGFloat

    func body(content: Content) -> some View {
        Color.clear
            .overlay(alignment: .top) {
                content
                    .fixedSize(horizontal: false, vertical: true)
                    .onSizeChanged { height = $0.height }
            }
            .frame(height: max(0, clippedHeight(height)))
            .clipped()
    }
}

// MARK: - View + ClippedHeight

extension View {
    func clippedHeight(
        _ clippedHeight: @escaping (CGFloat) -> CGFloat
    ) -> some View {
        modifier(ClippedHeight(clippedHeight: clippedHeight))
    }
}
