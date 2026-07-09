//
//  PreferredFont+UIFont.swift
//  FontManager
//
//  Created by Ben Shutt on 19/11/2020.
//

#if os(iOS)
import UIKit

public extension PreferredFont {

    /// `PreferredFont` to `Font`
    var font: UIFont? {
        return UIFont(name: fontName, size: CGFloat(fontSize))
    }
}

#endif
