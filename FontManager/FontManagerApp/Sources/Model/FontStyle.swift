//
//  FontStyle.swift
//  FontManager
//
//  Created by Ben Shutt on 06/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

enum FontStyle: String {
    case light
    case lightItalic
    case regular
    case regularItalic
    case semiBold
    case semiBoldItalic
    case bold
    case boldItalic
    case extraBold
    case extraBoldItalic
}

// MARK: - CustomStringConvertible

extension FontStyle: CustomStringConvertible {
    
    var description: String {
        return rawValue.capitalized // first character
    }
}
