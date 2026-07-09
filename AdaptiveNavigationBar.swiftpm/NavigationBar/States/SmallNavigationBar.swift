//
//  SmallNavigationBar.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 04/11/2023.
//

import SwiftUI

/// View for the small navigation bar state
struct SmallNavigationBar: View {
    var body: some View {
        Text("Small Navigation Bar")
            .font(.system(size: .smallFont, weight: .semibold))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, .hPadding)
            .padding(.vertical, .vPadding)
    }
}
