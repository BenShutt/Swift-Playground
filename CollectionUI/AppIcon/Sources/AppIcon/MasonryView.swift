//
//  AppIcon.swift
//  CollectionUI
//
//  Created by Ben Shutt on 02/06/2024.
//

import SwiftUI

@MainActor struct AppIcon: View {
    var body: some View {
        MasonryView(size: 600)
            .frame(width: .appIconWidth, height: .appIconHeight)
            .background(Color.appLightGray)
    }
}

private struct MasonryView: View {
    var size: CGFloat

    private var columnWidth: CGFloat { size * 0.275 }
    private var smallHeight: CGFloat { size * 0.3 }
    private var largeHeight: CGFloat { size * 0.6 }

    var body: some View {
        ZStack {
            ColorView(
                width: columnWidth,
                height: largeHeight,
                alignment: .topLeading
            )

            ColorView(
                width: columnWidth,
                height: smallHeight,
                alignment: .bottomLeading
            )

            ColorView(
                width: columnWidth,
                height: smallHeight,
                alignment: .top
            )

            ColorView(
                width: columnWidth,
                height: largeHeight,
                alignment: .bottom
            )

            ColorView(
                width: columnWidth,
                height: largeHeight,
                alignment: .topTrailing
            )

            ColorView(
                width: columnWidth,
                height: smallHeight,
                alignment: .bottomTrailing
            )
        }
        .frame(width: size, height: size)
    }
}

// MARK: - ColorView

private struct ColorView: View {
    var width: CGFloat
    var height: CGFloat
    var alignment: Alignment

    private var cornerRadius: CGFloat {
        width * 0.2
    }

    var body: some View {
        Color.appDarkGray
            .frame(width: width, height: height)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: alignment
            )
    }
}

private extension CGFloat {
    static let appIconWidth: CGFloat = 1024
    static let appIconHeight: CGFloat = 1024
}

// MARK: - Preview

#Preview {
    MasonryView(size: 250)
}
