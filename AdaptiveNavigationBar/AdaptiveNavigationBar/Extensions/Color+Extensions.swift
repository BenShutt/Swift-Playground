//
//  Color+Extensions.swift
//  AdaptiveNavigationBar
//
//  Created by Ben Shutt on 31/10/2023.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        Color(red: .random(), green: .random(), blue: .random())
    }
}

// MARK: - Double + Random

private extension Double {
    static func random() -> Double {
        .random(in: 0...1)
    }
}
