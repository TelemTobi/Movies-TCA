// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "Splash", targets: ["Splash"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Data"),
        .package(path: "../Domain"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.17.0")
    ],
    targets: [
        .target(
            name: "Splash",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Models", package: "Data"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/Features/Splash"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Splash"]
        )
    ]
)
