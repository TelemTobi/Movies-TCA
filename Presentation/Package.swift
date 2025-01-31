// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "DiscoveryFeature", targets: ["Discovery"]),
        .library(name: "MovieFeature", targets: ["Movie"]),
        .library(name: "MovieListFeature", targets: ["MovieList"]),
        .library(name: "PreferencesFeature", targets: ["Preferences"]),
        .library(name: "SearchFeature", targets: ["Search"]),
        .library(name: "SplashFeature", targets: ["Splash"]),
        .library(name: "WatchlistFeature", targets: ["Watchlist"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Data"),
        .package(path: "../Domain"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.17.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.2.0"),
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            path: "Sources/DesignSystem",
            resources: [.process("Resources/Assets.xcassets")]
        ),
        .target(
            name: "Discovery",
            path: "Sources/Features/Discovery"
        ),
        .target(
            name: "Movie",
            path: "Sources/Features/Movie"
        ),
        .target(
            name: "MovieList",
            path: "Sources/Features/MovieList"
        ),
        .target(
            name: "Preferences",
            path: "Sources/Features/Preferences"
        ),
        .target(
            name: "Search",
            path: "Sources/Features/Search"
        ),
        .target(
            name: "Splash",
            path: "Sources/Features/Splash"
        ),
        .target(
            name: "Watchlist",
            path: "Sources/Features/Watchlist"
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Splash"]
        )
    ],
    swiftLanguageModes: [.v5]
)

for target in package.targets where target.name != "DesignSystem" {
    target.dependencies.append("DesignSystem")
}

for target in package.targets {
    target.dependencies.append(contentsOf: [
        .product(name: "Core", package: "Core"),
        .product(name: "Models", package: "Data"),
        .product(name: "Domain", package: "Domain"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
        .product(name: "Pow", package: "Pow")

    ])
}
