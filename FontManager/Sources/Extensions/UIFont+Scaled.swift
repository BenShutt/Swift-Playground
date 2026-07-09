//
//  UIFont+Extensions.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//

#if os(iOS)
import UIKit

public extension UIFont {
    
    /// Create a default `UIFont` name from the given `font` and `weight`.
    /// Pass this name to `customFont(name:size:)`.
    ///
    /// - Parameters:
    ///   - font: A `CustomFont`
    ///   - weight: A `UIFont.Weight`
    ///   - size: Size of the `UIFont`
    static func scaledCustomFont(
        _ customFont: CustomFont,
        weight: UIFont.Weight,
        size: CGFloat
    ) -> UIFont? {
        return scaledFont(name: customFont.rawValue, weight: weight, size: size)
    }
    
    /// Create a`UIFont` for the given `name`, `weight`, and `size`.
    ///
    /// - Parameters:
    ///   - name: Name of the `UIFont`
    ///   - weight: A `UIFont.Weight`
    ///   - size: Size of the `UIFont`
    static func scaledFont(
        name: String,
        weight: UIFont.Weight,
        size: CGFloat
    ) -> UIFont? {
        let fontName = weight.fontName(name)
        return scaledFont(name: fontName, size: size)
    }
    
    /// Create a`UIFont` for the given `name`, and `size`.
    ///
    /// - Parameters:
    ///   - name: Name of the `UIFont`
    ///   - size: Size of the `UIFont`
    static func scaledFont(name: String, size: CGFloat) -> UIFont? {
        return UIFont(name: name, size: size)?.scaled()
    }
    
    /// Apply `.default` `UIFontMetrics` scaling to `self`
    func scaled() -> UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }

    // MARK: - UIFont.TextStyle

    /// Scaled preferred `UIFont` for the given `textStyle`
    ///
    /// - Parameter textStyle: `UIFont.TextStyle`
    static func scaledPreferredFont(
        forTextStyle textStyle: UIFont.TextStyle
    ) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: textStyle)
        return scaledFont(font, forTextStyle: textStyle)
    }

    /// Scaled `UIFont` for the given `font` and `textStyle`
    ///
    /// - Parameters:
    ///   - font: `UIFont`
    ///   - textStyle: `UIFont.TextStyle`
    static func scaledFont(
        _ font: UIFont,
        forTextStyle textStyle: UIFont.TextStyle
    ) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: font)
    }
}

#endif
