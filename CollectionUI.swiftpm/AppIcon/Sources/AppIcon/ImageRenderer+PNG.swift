//
//  ImageRenderer+PNG.swift
//  CollectionUI
//
//  Created by Ben Shutt on 10/07/2026.
//

import ImageIO
import SwiftUI
import UniformTypeIdentifiers

@MainActor
extension ImageRenderer {
    func pngData() throws(PNGEncodingError) -> Data {
        guard let cgImage else {
            throw .noContent
        }

        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(
            data,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            throw .destinationUnavailable
        }

        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw .encodingFailed
        }

        return data as Data
    }
}

// MARK: - PNGEncodingError

enum PNGEncodingError: Error, CustomStringConvertible {
    case noContent
    case destinationUnavailable
    case encodingFailed

    var description: String {
        switch self {
        case .noContent:
            "The renderer produced no image to encode"
        case .destinationUnavailable:
            "Could not create a PNG destination"
        case .encodingFailed:
            "Failed to encode the PNG data"
        }
    }
}
