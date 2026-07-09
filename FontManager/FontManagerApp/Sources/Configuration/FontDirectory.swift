//
//  FontDirectory.swift
//  FontManager
//
//  Created by Ben Shutt on 21/02/2020.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import Foundation

/// An `Error` in `FontDirectory`
enum FontDirectoryError: Error {
    
    /// Directory not provided as a command line argument
    case directoryNotProvided
    
    /// Directory provided either doesn't exist
    case directoryNotFound(url: URL)
    
    /// File at the provided path is not a directory
    case fileNotDirectory(url: URL)
    
    /// Directory provided doesn't contain any font files
    case noFontFiles(url: URL)
    
    /// When looking for a specific font by name but that font can not be found
    case fontNotFound(filename: String)
}

/// Intialize the app by acquiring and validating the font directory
struct FontDirectory {
    
    /// Font directory `URL` provided as command line argument
    let fontDirectory: URL
    
    /// `URL` of font files in `fontDirectory`
    let fontFiles: [URL]
    
    /// Initialize `FontConfiguration`.
    /// Get font dirctory file path from the command line arguments
    init() throws {
        // Check for a command line argument
        guard CommandLine.arguments.count > 1 else {
            throw FontDirectoryError.directoryNotProvided
        }
        
        try self.init(path: CommandLine.arguments[1])
    }
    
    /// Initialize `FontConfiguration` with the given `path`.
    /// Validate the font directory and ensure it contains at least 1 font file.
    ///
    /// - Parameter path: File path to font directory
    init(path: String) throws {
        let fm = FileManager.default
        
        // Get a URL reference to the path provided as argument
        let directory = URL(fileURLWithPath: path)

        // Check the directory at the given path exists
        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: directory.path, isDirectory: &isDirectory) else {
            throw FontDirectoryError.directoryNotFound(url: directory)
        }
        
        // And check it is a directory
        guard isDirectory.boolValue else {
            throw FontDirectoryError.fileNotDirectory(url: directory)
        }
        
        // Look for font files in the directory provided
        let contents = try fm.contentsOfDirectory(atPath: directory.path)
        let files = contents.filter {
            ($0 as NSString).pathExtension == FontConfiguration.shared.fontExtension
        }
        
        // Ensure there is at least 1 font
        guard files.count > 0 else {
            throw FontDirectoryError.noFontFiles(url: directory)
        }
        
        self.fontDirectory = directory
        self.fontFiles = files.map { directory.appendingPathComponent($0) }
    }
    
    /// Name of the font
    var fontName: String {
        return fontDirectory.lastPathComponent
    }
    
    /// Find the `URL` of the given `font`.
    /// - Parameter filename: Name of the font file
    func find(font: String) throws -> URL {
        let extn = ".\(FontConfiguration.shared.fontExtension)"
        let filename = font.suffixingIfRequired(extn)
        
        let url = fontDirectory.appendingPathComponent(filename)
        let file = fontFiles.first {
            $0.path.lowercased() == url.path.lowercased()
        }
    
        // Check to see if the desired font can be found
        if let fontFile = file {
            // Found desired font!
            return fontFile
        }
        
        // Failed to find desired font, fallback on a default if the
        // configuration permits
        let useDefault = FontConfiguration.shared.useDefaultFont
        if useDefault, let fontFile = fontFiles.first {
            return fontFile
        }
        
        // Failed to find a font for the given font name
        throw FontDirectoryError.fontNotFound(filename: filename)
    }
}
