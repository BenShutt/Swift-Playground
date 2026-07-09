//
//  OffsetScrollView.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 04/11/2023.
//

import SwiftUI

/// A `ScrollView` that fires a closure when its offset updates
///
/// # Reference
/// https://www.swiftbysundell.com/articles/observing-swiftui-scrollview-content-offset/
struct OffsetScrollView<Content: View>: View {

    /// Coordinate space of the scroll view
    private let coordinateSpace = "\(Self.self)"

    /// Closure than executes when the offset changes
    /// - Note: More performant than observing the `onChange` of an offset `@Binding`
    var onOffsetChange: (CGPoint) -> Void

    /// The content of the scroll view
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            content()
                .background(
                    GeometryView(coordinateSpace: coordinateSpace)
                )
        }
        .coordinateSpace(name: coordinateSpace)
        .onPreferenceChange(ScrollOffset.self) { value in
            onOffsetChange(value)
        }
    }
}

// MARK: - GeometryView

private struct GeometryView: View {
    var coordinateSpace: String

    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: ScrollOffset.self,
                value: {
                    let origin = proxy.frame(in: .named(coordinateSpace)).origin
                    return CGPoint(x: -origin.x, y: -origin.y)
                }()
            )
        }
    }
}

// MARK: - ScrollOffset

private struct ScrollOffset: PreferenceKey {
    static let defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
