//
//  CustomFont.swift
//  FontManager
//
//  Created by Ben Shutt on 16/02/2020.
//  Copyright © 2020 Moor. All rights reserved.
//

import Foundation

/// A custom font added to the app
/// Font could be  `String` enum
/// E.g. `openSans = "OpenSans"`
public protocol CustomFont {
    var rawValue: String { get }
}

extension CustomFont where Self: RawRepresentable, Self.RawValue == String {
}
