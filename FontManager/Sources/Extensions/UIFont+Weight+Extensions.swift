//
//  UIFont+Weight+Extensions.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//

#if os(iOS)
import UIKit

// MARK: - UIFont.Weight + CaseIterable

extension UIFont.Weight: CaseIterable {
    public typealias AllCases = [UIFont.Weight]

    /// All known `UIFont.Weight`s at time of writing
    public static var allCases: [UIFont.Weight] {
        return [
            .ultraLight,
            .thin,
            .light,
            .regular,
            .medium,
            .semibold,
            .bold,
            .heavy,
            .black
        ]
    }
}

// MARK: - UIFont.Weight + CustomStringConvertible

extension UIFont.Weight: CustomStringConvertible {
    
    /// Map `UIFont.Weight` to a name.
    ///
    /// - Warning:
    /// `String`s are hardcoded in English
    private static var nameMap: [UIFont.Weight: String] {
        return [
            .ultraLight : "UltraLight",
            .thin : "Thin",
            .light : "Light",
            .regular : "Regular",
            .medium : "Medium",
            .semibold : "SemiBold",
            .bold : "Bold",
            .heavy : "Heavy",
            .black : "Black"
        ]
    }

    /// Map instance to `String` using `nameMap`
    public var description: String {
        return UIFont.Weight.nameMap[self] ?? ""
    }
}

// MARK: - FontName

public extension UIFont.Weight {

    /// Suffix instance to end of `fontName` separated with a hyphen.
    ///
    /// - Warning:
    /// This is the **expected** name based on `fontName` and the `UIFont.Weight` instance
    ///
    /// - Parameter fontName: `String` name of `UIFont`
    func fontName(_ fontName: String) -> String {
        return "\(fontName)-\(self)"
    }
}

#endif
