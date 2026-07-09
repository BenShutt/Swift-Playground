// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FontManagerApp",
    platforms: [
        .macOS(.v10_12)
    ],
    dependencies: [
        .package(path: "..")
    ],
    targets: [
        .target(
            name: "FontManagerApp",
            dependencies: ["FontManager"],
            path: "Sources"
        ),
        .testTarget(
            name: "FontManagerAppTests",
            dependencies: ["FontManagerApp"]
        )
    ]
)

