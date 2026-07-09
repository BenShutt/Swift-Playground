//
//  PreferredFont.swift
//  FontManager
//
//  Created by Ben Shutt on 06/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// An element in the `PropertyList` font file
public struct PreferredFont: Codable {
              
    /// Name of the font
    public var fontName: String
    
    /// Size of the font
    public var fontSize: Float
    
    /// Default public memberwise initialization
    ///
    /// - Parameters:
    ///   - fontName: `String`
    ///   - fontSize: `Float`
    public init(fontName: String, fontSize: Float) {
        self.fontName = fontName
        self.fontSize = fontSize
    }
}
