//
//  Screen.swift
//  Coordinator
//
//  Created by Ben Shutt on 22/10/2024.
//

import SwiftUI

// MARK: - Screen

struct Screen {
    struct Button {
        var title: LocalizedStringKey
        var action: () -> Void
    }

    var color: Color
    var title: LocalizedStringKey
    var button: Button?
}

// MARK: - ScreenView

struct ScreenView: View {
    var screen: Screen? // Optional due to init(rootView:)

    var body: some View {
        if let screen {
            screen.color
                .ignoresSafeArea()
                .overlay {
                    VStack(spacing: 20) {
                        Text(screen.title)
                            .font(.title)

                        if let button = screen.button {
                            Button(action: {
                                button.action()
                            }, label: {
                                Text(button.title)
                            })
                        }
                    }
                }
        }
    }
}

// MARK: - Preview

#Preview {
    ScreenView(
        screen: .init(
            color: .gray,
            title: "Preview",
            button: .init(
                title: "Navigate",
                action: {}
            )
        )
    )
}
