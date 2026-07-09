//
//  NavigationBarBackground.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 31/10/2023.
//

import SwiftUI

/// Background view of the navigation bar
struct NavigationBarBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                .blue.opacity(0.1),
                .blue.opacity(0.3)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .background(Color.white)
        .compositingGroup()
        .shadow(radius: 3)
    }
}

// MARK: - Preview

#Preview {
    NavigationBarBackground()
}
