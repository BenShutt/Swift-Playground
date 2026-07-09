//
//  ContentView.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 31/10/2023.
//

import SwiftUI

struct ContentView: View {
    let colors = (1...20).map { ($0, Color.random()) }

    var body: some View {
        NavigationBarScreen {
            LazyVStack(spacing: 0) {
                ForEach(colors, id: \.0) { _, color in
                    color
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
