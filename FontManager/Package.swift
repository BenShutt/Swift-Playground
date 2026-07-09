// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FontManager",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        //.tvOS(.v10),
        //.watchOS(.v3)
    ],
    products: [
        .library(
            name: "FontManager",
            targets: ["FontManager"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FontManager",
            path: "Sources"
        ),
        .testTarget(
            name: "FontManagerTests",
            dependencies: ["FontManager"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
