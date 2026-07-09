// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FontManager",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "FontManager",
            targets: ["FontManager"]
        ),
        .executable(
            name: "FontManagerApp",
            targets: ["FontManagerApp"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FontManager",
            path: "Sources"
        ),
        .target(
            name: "FontManagerApp",
            dependencies: ["FontManager"],
            path: "FontManagerApp/Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
