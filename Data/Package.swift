// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "TmdbApi", targets: ["TmdbApi"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/telemtobi/swift-networking.git", from: "1.3.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.4.0"),
        .package(url: "https://github.com/pointfreeco/swift-sharing", "0.1.2"..<"3.0.0"),
        .package(url: "https://github.com/telemtobi/swift-localization", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Networking", package: "swift-networking"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Sharing", package: "swift-sharing"),
                .product(name: "Localization", package: "swift-localization")
            ]
        ),
        .target(
            name: "TmdbApi",
            dependencies: [
                "Models",
                .product(name: "Core", package: "Core"),
                .product(name: "Networking", package: "swift-networking"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            resources: [.process("Mock/Resources")]
        )
    ]
)
