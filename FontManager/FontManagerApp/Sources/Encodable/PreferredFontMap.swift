//
//  PreferredFontMap.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation
import FontManager

/// Map a `FontPropertyListKey` to a `PreferredFont`
/// Use `rawValue (String)` so property list writes the keys as expected.
typealias PreferredFontMap = [String : PreferredFont]

/// Write a plist file which maps a (preferred) font style to the name of the custom font
final class PreferredFontMapping: FontEncodableBase<PreferredFontMap> {
    
    /// Use the `FontConfiguration.shared.preferredFontFileName` if defined.
    /// Fallback on name of the font (most common case).
    override func plistName() -> String {
        return FontConfiguration.shared.preferredFontFileName ?? super.plistName()
    }
    
    /// `PreferredFontMap` from the given `fontDirectory`
    /// - Parameter directory: `FontDirectory`
    override func encodable() throws -> PreferredFontMap {
        return try Dictionary(uniqueKeysWithValues: FontPropertyListKey.allCases.map {
            let expected = $0.expectedFontName(fontName: directory.fontName)
            let url = try directory.find(font: expected)
            let fontName = url.filenameWithoutExtension
            return ($0.rawValue, PreferredFont(fontName: fontName, fontSize: $0.fontSize))
        })
    }
}
