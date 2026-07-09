//
//  FontPropertyListKey.swift
//  FontManager
//
//  Created by Ben Shutt on 06/12/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

enum FontPropertyListKey: String, CaseIterable, Codable {
    case UICTFontTextStyleTitle0
    case UICTFontTextStyleTitle1
    case UICTFontTextStyleTitle2
    case UICTFontTextStyleTitle3
    case UICTFontTextStyleHeadline
    case UICTFontTextStyleSubhead
    case UICTFontTextStyleBody
    case UICTFontTextStyleCallout
    case UICTFontTextStyleFootnote
    case UICTFontTextStyleCaption1
    case UICTFontTextStyleCaption2
    
    /// Default size
    var fontSize: Float {
        switch self {
        case .UICTFontTextStyleTitle0: return 34
        case .UICTFontTextStyleTitle1: return 28
        case .UICTFontTextStyleTitle2: return 22
        case .UICTFontTextStyleTitle3: return 20
        case .UICTFontTextStyleHeadline: return 17
        case .UICTFontTextStyleSubhead: return 15
        case .UICTFontTextStyleBody: return 17
        case .UICTFontTextStyleCallout: return 16
        case .UICTFontTextStyleFootnote: return 13
        case .UICTFontTextStyleCaption1: return 12
        case .UICTFontTextStyleCaption2: return 11
        }
    }
    
    /// Default style
    var style: FontStyle {
        switch self {
        case .UICTFontTextStyleTitle0: return .bold
        case .UICTFontTextStyleTitle1: return .bold
        case .UICTFontTextStyleTitle2: return .bold
        case .UICTFontTextStyleTitle3: return .bold
        case .UICTFontTextStyleHeadline: return .bold
        case .UICTFontTextStyleSubhead: return .semiBold
        case .UICTFontTextStyleBody: return .regular
        case .UICTFontTextStyleCallout: return .light
        case .UICTFontTextStyleFootnote: return .light
        case .UICTFontTextStyleCaption1: return .light
        case .UICTFontTextStyleCaption2: return .light
        }
    }
    
    /// Name of the expected font for the given `fontName`.
    /// Specifically, given:
    /// - `fontName = "OpenSans"`
    /// - `self = UICTFontTextStyleTitle0`
    /// then we could expect the corresponding font name to be `OpensSans-Light`
    ///
    /// - Parameter fontName: Name of the font
    func expectedFontName(fontName: String) -> String {
        return "\(fontName)-\(style)"
    }
}
