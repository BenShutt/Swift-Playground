import Foundation
import SwiftUI

guard CommandLine.arguments.count == 2 else {
    fatalError("Please pass URL to write to")
}

let url = URL(filePath: CommandLine.arguments[1])
let renderer = ImageRenderer(content: AppIcon())
renderer.scale = 1 // Fixed 1x scaling

do {
    let pngData = try renderer.pngData()
    try pngData.write(to: url, options: .atomic)
    print("Success, written to \(url)")
} catch {
    let errorMessage = "Error: \(error)\n"
    FileHandle.standardError.write(Data(errorMessage.utf8))
    exit(EXIT_FAILURE)
}
