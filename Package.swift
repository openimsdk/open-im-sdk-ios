// swift-tools-version: 5.9

import PackageDescription
import Foundation

let useLocalCore = FileManager.default.fileExists(atPath: "/Volumes/T7/Dev/Framework/openim-sdk-core-ios/Package.swift")

let package = Package(
    name: "OpenIMSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "OpenIMSDK",
            targets: ["OpenIMSDK"]
        )
    ],
    dependencies: [
        useLocalCore
            ? .package(name: "OpenIMSDKCore", path: "/Volumes/T7/Dev/Framework/openim-sdk-core-ios")
            : .package(url: "https://github.com/openimsdk/openim-sdk-core-ios.git", branch: "feature/swift-sdk-rewrite")
    ],
    targets: [
        .target(
            name: "OpenIMSDK",
            dependencies: [
                .product(name: "OpenIMCore", package: "OpenIMSDKCore", condition: .when(platforms: [.iOS]))
            ],
            path: "Sources/OpenIMSDK",
            linkerSettings: [
                .linkedLibrary("resolv")
            ]
        ),
        .testTarget(
            name: "OpenIMSDKTests",
            dependencies: ["OpenIMSDK"],
            path: "Tests/OpenIMSDKTests"
        )
    ]
)
