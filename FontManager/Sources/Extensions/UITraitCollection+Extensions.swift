//
//  UITraitCollection+Extensions.swift
//  FontManager
//
//  Created by Ben Shutt on 19/11/2020.
//

#if os(iOS)
import UIKit

// MARK: - UITraitCollection

extension UITraitCollection {

    /// Default `UITraitCollection`.
    ///
    /// # Not:
    /// `.large` seems to be the default `UIContentSizeCategory`
    static let `default` = UITraitCollection(preferredContentSizeCategory: .large)
}

#endif
