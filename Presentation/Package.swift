// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        
        .library(name: "DiscoveryFeature", targets: ["DiscoveryFeature"]),
        .library(name: "MovieDetailsFeature", targets: ["MovieDetailsFeature"]),
        .library(name: "MovieListFeature", targets: ["MovieListFeature"]),
        .library(name: "PreferencesFeature", targets: ["PreferencesFeature"]),
        .library(name: "SearchFeature", targets: ["SearchFeature"]),
        .library(name: "SplashFeature", targets: ["SplashFeature"]),
        .library(name: "WatchlistFeature", targets: ["WatchlistFeature"]),
        
        .library(name: "DiscoveryNavigator", targets: ["DiscoveryNavigator"]),
        .library(name: "HomeNavigator", targets: ["HomeNavigator"]),
        .library(name: "MovieNavigator", targets: ["MovieNavigator"]),
        .library(name: "RootNavigator", targets: ["RootNavigator"]),
        .library(name: "SearchNavigator", targets: ["SearchNavigator"]),
        .library(name: "WatchlistNavigator", targets: ["WatchlistNavigator"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Data"),
        .package(path: "../Domain"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.17.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.8.0"),
        .package(url: "https://github.com/EmergeTools/Pow", from: "1.0.0"),
        .package(url: "https://github.com/telemtobi/swift-localization", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Models", package: "Data"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "Pow", package: "Pow"),
                .product(name: "Localization", package: "swift-localization")
            ],
            path: "Sources/DesignSystem",
            resources: [
                .process("Resources/Assets.xcassets")
            ]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: [
                "DiscoveryFeature",
                "MovieDetailsFeature",
                "MovieListFeature",
                "PreferencesFeature",
                "SearchFeature",
                "SplashFeature",
                "WatchlistFeature",
                "DiscoveryNavigator",
                "HomeNavigator",
                "MovieNavigator",
                "RootNavigator",
                "SearchNavigator",
                "WatchlistNavigator",
                .product(name: "Core", package: "Core"),
                .product(name: "Models", package: "Data"),
                .product(name: "Domain", package: "Domain")
            ]
        )
    ],
    swiftLanguageModes: [.v5]
)

// MARK: - Features

let features: [PackageDescription.Target] = [
    .target(
        name: "DiscoveryFeature",
        path: "Sources/Features/Discovery"
    ),
    .target(
        name: "MovieDetailsFeature",
        path: "Sources/Features/MovieDetails"
    ),
    .target(
        name: "MovieListFeature",
        path: "Sources/Features/MovieList"
    ),
    .target(
        name: "PreferencesFeature",
        path: "Sources/Features/Preferences"
    ),
    .target(
        name: "SearchFeature",
        path: "Sources/Features/Search"
    ),
    .target(
        name: "SplashFeature",
        path: "Sources/Features/Splash"
    ),
    .target(
        name: "WatchlistFeature",
        path: "Sources/Features/Watchlist"
    )
]

for target in features {
    target.dependencies.append(contentsOf: [
        "DesignSystem",
        .product(name: "Core", package: "Core"),
        .product(name: "Models", package: "Data"),
        .product(name: "Domain", package: "Domain"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "NukeUI", package: "Nuke"),
        .product(name: "Pow", package: "Pow"),
        .product(name: "Localization", package: "swift-localization")
    ])
}

// MARK: - Navigators

let navigators: [PackageDescription.Target] = [
    .target(
        name: "DiscoveryNavigator",
        dependencies: [
            "DiscoveryFeature",
            "MovieListFeature",
            "PreferencesFeature",
            "MovieNavigator"
        ],
        path: "Sources/Navigators/Discovery"
    ),
    .target(
        name: "HomeNavigator",
        dependencies: [
            "DiscoveryNavigator",
            "SearchNavigator",
            "WatchlistNavigator"
        ],
        path: "Sources/Navigators/Home"
    ),
    .target(
        name: "MovieNavigator",
        dependencies: [
            "MovieDetailsFeature"
        ],
        path: "Sources/Navigators/Movie"
    ),
    .target(
        name: "RootNavigator",
        dependencies: [
            "SplashFeature",
            "HomeNavigator"
        ],
        path: "Sources/Navigators/Root"
    ),
    .target(
        name: "SearchNavigator",
        dependencies: [
            "SearchFeature",
            "PreferencesFeature",
            "MovieNavigator"
        ],
        path: "Sources/Navigators/Search"
    ),
    .target(
        name: "WatchlistNavigator",
        dependencies: [
            "WatchlistFeature",
            "PreferencesFeature",
            "MovieNavigator"
        ],
        path: "Sources/Navigators/Watchlist"
    )
]

for target in navigators {
    target.dependencies.append(contentsOf: [
        "DesignSystem",
        .product(name: "Core", package: "Core"),
        .product(name: "Models", package: "Data"),
        .product(name: "Domain", package: "Domain"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Localization", package: "swift-localization")
    ])
}

package.targets.append(contentsOf: [features, navigators].flatMap { $0 })
