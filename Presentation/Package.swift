// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        
        .library(name: "GenreDetailsFeature", targets: ["GenreDetailsFeature"]),
        .library(name: "MoviesHomepageFeature", targets: ["MoviesHomepageFeature"]),
        .library(name: "MovieDetailsFeature", targets: ["MovieDetailsFeature"]),
        .library(name: "MovieCollectionFeature", targets: ["MovieCollectionFeature"]),
        .library(name: "PreferencesFeature", targets: ["PreferencesFeature"]),
        .library(name: "SearchFeature", targets: ["SearchFeature"]),
        .library(name: "SplashFeature", targets: ["SplashFeature"]),
        
        .library(name: "HomeNavigator", targets: ["HomeNavigator"]),
        .library(name: "MoviesNavigator", targets: ["MoviesNavigator"]),
        .library(name: "MovieNavigator", targets: ["MovieNavigator"]),
        .library(name: "RootNavigator", targets: ["RootNavigator"]),
        .library(name: "SearchNavigator", targets: ["SearchNavigator"]),
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
                "GenreDetailsFeature",
                "MoviesHomepageFeature",
                "MovieDetailsFeature",
                "MovieCollectionFeature",
                "PreferencesFeature",
                "SearchFeature",
                "SplashFeature",
                "HomeNavigator",
                "MoviesNavigator",
                "MovieNavigator",
                "RootNavigator",
                "SearchNavigator",
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
        name: "GenreDetailsFeature",
        dependencies: [
            "MovieCollectionFeature"
        ],
        path: "Sources/Features/GenreDetails"
    ),
    .target(
        name: "MoviesHomepageFeature",
        path: "Sources/Features/MoviesHomepage"
    ),
    .target(
        name: "MovieDetailsFeature",
        path: "Sources/Features/MovieDetails"
    ),
    .target(
        name: "MovieCollectionFeature",
        path: "Sources/Features/MovieCollection"
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
        name: "HomeNavigator",
        dependencies: [
            "MoviesNavigator",
            "SearchNavigator"
        ],
        path: "Sources/Navigators/Home"
    ),
    .target(
        name: "MoviesNavigator",
        dependencies: [
            "GenreDetailsFeature",
            "MoviesHomepageFeature",
            "MovieCollectionFeature",
            "PreferencesFeature",
            "MovieNavigator"
        ],
        path: "Sources/Navigators/Movies"
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
            "GenreDetailsFeature",
            "PreferencesFeature",
            "MovieNavigator"
        ],
        path: "Sources/Navigators/Search"
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
