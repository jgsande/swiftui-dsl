// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let enableDeveloperTools = false
let defaultTraits: Set<String> = if enableDeveloperTools {
    ["MapLibreDeveloper"]
} else {
    []
}

let package = Package(
    name: "MapLibreSwiftUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "MapLibreSwiftUI",
            targets: ["MapLibreSwiftUI"]
        ),
        .library(
            name: "MapLibreSwiftDSL",
            targets: ["MapLibreSwiftDSL"]
        ),
    ],
    traits: [
        .default(enabledTraits: defaultTraits),
        .trait(name: "MapLibreDeveloper"),
    ],
    dependencies: [
        .package(url: "https://github.com/maplibre/maplibre-gl-native-distribution.git", from: "6.21.2"),
        // Testing
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.1.1"),
        .package(url: "https://github.com/Kolos65/Mockable.git", from: "0.5.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.7"),
    ],
    targets: [
        .target(
            name: "MapLibreSwiftUI",
            dependencies: [
                .target(name: "InternalUtils"),
                .target(name: "MapLibreSwiftDSL"),
                .product(name: "MapLibre", package: "maplibre-gl-native-distribution"),
                .product(name: "Mockable", package: "Mockable", condition: .when(traits: ["MapLibreDeveloper"])),
            ],
            swiftSettings: [
                .define("MOCKING", .when(configuration: .debug)),
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .target(
            name: "MapLibreSwiftDSL",
            dependencies: [
                .target(name: "InternalUtils"),
                .product(name: "MapLibre", package: "maplibre-gl-native-distribution"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .target(
            name: "InternalUtils",
            dependencies: [
                .product(name: "MapLibre", package: "maplibre-gl-native-distribution"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),

        // MARK: Tests

        .testTarget(
            name: "MapLibreSwiftUITests",
            dependencies: [
                "MapLibreSwiftUI",
                .product(name: "MapLibre", package: "maplibre-gl-native-distribution"),
                .product(name: "Numerics", package: "swift-numerics"),
                .product(name: "Mockable", package: "Mockable"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
        .testTarget(
            name: "MapLibreSwiftDSLTests",
            dependencies: [
                "MapLibreSwiftDSL",
            ]
        ),
    ],
    swiftLanguageModes: [.v5] // TODO: we need to enable v6
)
