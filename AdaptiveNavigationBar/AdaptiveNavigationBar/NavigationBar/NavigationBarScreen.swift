//
//  NavigationBarScreen.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 31/10/2023.
//

import SwiftUI

struct NavigationBarScreen<Content: View>: View {
    @State private var offsetY: CGFloat = 0
    @State private var smallNavigationBarHeight: CGFloat = 0
    @State private var largeNavigationBarHeight: CGFloat = 0

    @ViewBuilder var content: () -> Content

    private var heightDifference: CGFloat {
        max(0, largeNavigationBarHeight - smallNavigationBarHeight)
    }

    var body: some View {
        OffsetScrollView(onOffsetChange: { offset in
            offsetY = offset.y
        }, content: {
            content()
                .padding(.top, heightDifference)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, smallNavigationBarHeight)
        .overlay(alignment: .top) {
            NavigationBar(
                offsetY: offsetY,
                maxOffsetY: heightDifference,
                smallNavigationBar: {
                    SmallNavigationBar()
                        .onSizeChanged { smallNavigationBarHeight = $0.height }
                },
                largeNavigationBar: {
                    LargeNavigationBar()
                        .onSizeChanged { largeNavigationBarHeight = $0.height }
                }
            )
        }
    }
}
