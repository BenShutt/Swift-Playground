// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "OCR-MEI-B",
    targets: [
        .target(name: "Utilities", path: "Utilities"),
        .examTarget("PS_Oct_2021"),
        .examTarget("PM_Jun_2022"),
        .examTarget("PS_Jun_2022"),
        .examTarget("PS_Jun_2018"),
    ]
)

private extension Target {
    static func examTarget(_ name: String) -> Target {
        .executableTarget(
            name: name,
            dependencies: ["Utilities"],
            path: name,
            exclude: ["Resources"]
        )
    }
}
