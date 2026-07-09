//
//  NavigationBar.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 31/10/2023.
//

import SwiftUI

import SwiftUI

/// Custom view used for navigation bar UI.
/// The view transitions from a large to small state as the scroll offset increases.
struct NavigationBar<SmallContent: View, LargeContent: View>: View {

    /// The content offset in Y of the scroll view
    var offsetY: CGFloat

    /// Critical scroll offset in Y for the different states
    var maxOffsetY: CGFloat

    /// Make the small navigation bar content
    @ViewBuilder var smallNavigationBar: () -> SmallContent

    /// Make the large navigation bar content
    @ViewBuilder var largeNavigationBar: () -> LargeContent

    /// Value in `[0, 1]`.
    /// Progress from not scrolled to fully scrolled (respectively)
    private var progress: CGFloat {
        max(0, min(1, offsetY / maxOffsetY))
    }

    /// Value in `[0, 1]`.
    /// Opacity of the small navigation bar as a function of progress
    /// - Note: Resolves 2x the rate of progress
    private var smallOpacity: CGFloat {
        max(0, 2 * progress - 1)
    }

    /// Value in `[0, 1]`.
    /// Opacity of the large navigation bar as a function of progress
    /// - Note: Resolves 2x the rate of progress
    private var largeOpacity: CGFloat {
        max(0, 1 - 2 * progress)
    }

    /// Value in `[-maxOffsetY, 0]`.
    /// Offset in Y of the large navigation bar as a function of progress
    private var largeOffset: CGFloat {
        max(-maxOffsetY, min(0, -offsetY))
    }

    var body: some View {
        ZStack(alignment: .top) {
            smallNavigationBar()
                .opacity(smallOpacity)

            largeNavigationBar()
                .opacity(largeOpacity)
                .offset(y: largeOffset)
                .clippedHeight { contentHeight in
                    contentHeight + largeOffset
                }
        }
        .background {
            NavigationBarBackground()
                .ignoresSafeArea(edges: .top)
        }
    }
}
