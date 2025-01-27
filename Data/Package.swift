// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "TmdbApi", targets: ["TmdbApi"])
    ],
    dependencies: [
        .package(url: "https://github.com/telemtobi/swift-networking.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "Models"
        ),
        .target(
            name: "TmdbApi",
            dependencies: [
                .product(name: "Networking", package: "swift-networking")
            ]
        )
    ]
)
