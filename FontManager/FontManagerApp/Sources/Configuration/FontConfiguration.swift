//
//  WriteConfig.swift
//  FontManager
//
//  Created by Ben Shutt on 22/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// Configurable settings read that can be read into a configuration file
public struct FontConfiguration: Codable {
    
    /// Attempt to read the configuration file, fallback on the default
    static var shared: FontConfiguration = {
        let configURL = FileManager.default.fontConfigurationURL
        let config: FontConfiguration? = try? PropertyList.read(from: configURL)
        return config ?? FontConfiguration()
    }()
    
    /// Font file extensions to use
    var fontExtension = "ttf"
    
    /// Name of the `PropertyList` file containing list of fonts to add to `Info.plist`
    var infoFileName = "font-info"
    
    /// Name of the `PropertyList` file containing `PreferredFont` mapping.
    /// `nil` will use the name of the font by default
    var preferredFontFileName: String? = nil
    
    /// When looking for a font of a specific type and it's prefered type could not be found, use a default
    var useDefaultFont = true
}

// MARK: - Extensions

private extension FileManager {
    
    /// `URL` of the `FontConfiguration` file
    var fontConfigurationURL: URL {
        return URL(fileURLWithPath: currentDirectoryPath)
            .appendingPathComponent(Constants.configurationFileName)
    }
}
