//
//  Constants.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// Fixed app constants, these can not be configured
struct Constants {
    
    /// Fonts key in `Info.plist`
    static let fontsKey = "UIAppFonts"
    
    /// `PropertyList` file extension
    static let propertyListExtension = "plist"
    
    /// Name of the configuration file to read the user settings - doesn't have to exist
    static let configurationFileName = "fontManagerConfig.\(propertyListExtension)"
}
