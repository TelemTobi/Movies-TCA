// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Domain", targets: ["Domain"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Data"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.4.0"),
        .package(url: "https://github.com/telemtobi/swift-localization", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Models", package: "Data"),
                .product(name: "TmdbApi", package: "Data"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Localization", package: "swift-localization")
            ]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]
        )
    ]
)
