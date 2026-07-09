//
//  Font.swift
//  FontManager
//
//  Created by Ben Shutt on 09/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

#if os(iOS)
import UIKit

/// Manage global app fonts
public final class Font {
    
    /// The selected shared `FontManager` instance.
    public static var fontManager: FontManager?
    
    // MARK: - Helper
    
    /// Get a `UIFont` for the given `textStyle`.
    /// Use the `default` `FontManager`
    ///
    /// - Parameter textStyle: `UIFont.TextStyle` of the font
    public static func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        return fontManager?.font(forTextStyle: textStyle) ??
            UIFont.scaledPreferredFont(forTextStyle: textStyle)
    }
    
    /// `UIFont` for a given `weight` and `size` based on `fontManager`
    /// Return a default if not found
    ///
    /// - Parameters:
    ///   - size: `CGFloat` size of font
    ///   - weight: `UIFont.Weight` of the `UIFont`
    public static func font(
        ofSize size: CGFloat,
        weight: UIFont.Weight
    ) -> UIFont {
        guard
            let fontName = fontManager?.fontName,
            let font = UIFont.scaledFont(name: fontName, weight: weight, size: size)
        else {
            return UIFont.systemFont(ofSize: size, weight: weight).scaled()
        }

        return font
    }
    
    /// `UIFont` for a given `size` based on `fontManager`, return a default if not found
    /// - Parameter size: `CGFloat` size of font
    public static func font(ofSize size: CGFloat) -> UIFont {
        guard
            let fontName = fontManager?.fontName,
            let font = UIFont.scaledFont(name: fontName, size: size)
        else {
            return UIFont.systemFont(ofSize: size).scaled()
        }
        
        return font
    }
}

#endif
