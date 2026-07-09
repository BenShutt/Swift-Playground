//
//  UIFont-TextStyle+Extensions.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//

#if os(iOS)
import UIKit

// MARK: - UIFont.TextStyle + Size

public extension UIFont.TextStyle {
    
    /// Default font size pre accessibility scaling for a given `textStyle`
    ///
    /// - Parameter textStyle: The `UIFont.TextStyle`
    static func defaultSize(_ textStyle: UIFont.TextStyle) -> CGFloat {
        return UIFontDescriptor.preferredFontDescriptor(
            withTextStyle: textStyle,
            compatibleWith: .default
        ).pointSize
    }
    
    /// Default size for `UIFont.TextStyle`
    var defaultSize: CGFloat {
        return UIFont.TextStyle.defaultSize(self)
    }
}

// MARK: - UIFont.TextStyle + CustomStringConvertible

extension UIFont.TextStyle: CustomStringConvertible {

    /// Readable name for `UIFont.TextStyle`
    public var description: String {
        let lower = rawValue.lowercased()
        let replaced = lower.replacingOccurrences(of: "uictfonttextstyle", with: "")
        return replaced.capitalized
    }
}

// MARK: - UIFont.TextStyle + CaseIterable

extension UIFont.TextStyle: CaseIterable {
    public typealias AllCases = [UIFont.TextStyle]

    /// All known `UIFont.TextStyle`s at time of writing
    public static var allCases: [UIFont.TextStyle] {
        return [
            .largeTitle,
            .title1,
            .title2,
            .title3,
            .headline,
            .subheadline,
            .body,
            .callout,
            .footnote,
            .caption1,
            .caption2
        ]
    }
}

#endif
