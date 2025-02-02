// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/telemtobi/swift-localization", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Localization", package: "swift-localization")
            ]
        )
    ]
)
