//
//  FlowLayoutConfiguration.swift
//  FlowLayout
//
//  Created by Ben Shutt on 20/08/2024.
//

import SwiftUI

/// Layout properties of the flow layout
public struct FlowLayoutConfiguration {

    /// Horizontal spacing between elements in a row
    public var hSpacing: CGFloat

    /// Vertical spacing between rows
    public var vSpacing: CGFloat

    /// Margins/edge insets
    public var padding: EdgeInsets

    /// Public memberwise initializer
    public init(
        hSpacing: CGFloat = 0,
        vSpacing: CGFloat = 0,
        padding: EdgeInsets = .zero
    ) {
        self.padding = padding
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
}

// MARK: - EdgeInsets + Extensions

public extension EdgeInsets {
    static let zero = EdgeInsets(
        top: 0,
        leading: 0,
        bottom: 0,
        trailing: 0
    )
}
