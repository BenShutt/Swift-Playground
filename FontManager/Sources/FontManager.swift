//
//  FontManager.swift
//  FontManager
//
//  Created by Ben Shutt on 06/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

#if os(iOS)
import UIKit

/// Font `Dictionary` mapping font styles to `PreferredFont`s
public typealias PreferredFontMap = [UIFont.TextStyle.RawValue: PreferredFont]

/// A utility class to help you use custom fonts with
/// dynamic type.
///
/// To use this class you must supply the name of a style
/// dictionary for the font when creating the class. The
/// style dictionary should be stored as a property list
/// file in the main bundle.
///
/// The style dictionary contains an entry for each text
/// style that uses the raw string value for each
/// `UIFont.TextStyle` as the key.
///
/// The value of each entry is a dictionary with two keys:
///
/// + fontName: A String which is the font name.
/// + fontSize: A number which is the point size to use
///             at the `.large` content size.
///
/// For example to use a 17 pt Noteworthy-Bold font
/// for the `.headline` style at the `.large` content size:
///
///     <dict>
///         <key>UICTFontTextStyleHeadline</key>
///         <dict>
///             <key>fontName</key>
///             <string>Noteworthy-Bold</string>
///             <key>fontSize</key>
///             <integer>17</integer>
///         </dict>
///     </dict>
///
/// You do not need to include an entry for every text style
/// but if you try to use a text style that is not included
/// in the dictionary it will fallback to the system preferred
/// font.
///
/// Ref:  https://github.com/kharrison/CodeExamples/tree/master/ScaledFont
public final class FontManager {

    /// The preferred font name the `FontManager` to initialize with
    public let fontName: String
    
    /// `PreferredFontMap` read from `PropertyList`
    public let fontMap: PreferredFontMap?
    
    /// Create a `FontManager`
    ///
    /// - Parameter fontName: Name of a plist file (without the extension)
    ///   in the main bundle that contains the style dictionary used to
    ///   scale fonts for each text style.
    public init(fontName: String) {
        self.fontName = fontName
        fontMap = FontManager.loadPlist(fontName: fontName)
    }
    
    /// Load a plist for the given `fontName` into a `PreferredFontMap`
    ///
    /// - Parameter fontName: The name of the `.plist` file with the `PreferredFont`s
    /// - Returns: `PreferredFontMap`
    public static func loadPlist(fontName: String) -> PreferredFontMap? {
        guard let url = Bundle.main.url(forResource: fontName, withExtension: "plist"),
            let data = try? Data(contentsOf: url) else {
                return nil
        }
        
        return try? PropertyListDecoder().decode(PreferredFontMap.self, from: data)
    }
    
    /// Get the scaled font for the given text style using the style dictionary supplied
    /// at initialization.
    ///
    /// - Parameter textStyle: The `UIFontTextStyle` for the font.
    /// - Returns: A `UIFont` of the custom font that has been
    ///   scaled for the users currently selected preferred text size.
    ///
    /// - Note: If the style dictionary does not have a font for this text style the default preferred
    ///   font is returned.
    public func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        guard #available(iOS 11, *),
            let preferredFont = fontMap?[textStyle.rawValue],
            let font = preferredFont.font
        else {
            return UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        return UIFont.scaledFont(font, forTextStyle: textStyle)
    }
}

#endif
