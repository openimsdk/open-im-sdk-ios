// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "OpenIMSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "OpenIMSDK",
            targets: ["OpenIMSDK"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/OpenIMSDK/Open-IM-SDK-Core.git", .exact("3.8.3")),
        .package(url: "https://github.com/CoderMJLee/MJExtension.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "OpenIMSDK",
            dependencies: [
                "OpenIMSDKCore",
                "MJExtension",
                .target(name: "Utils"),
                .target(name: "CallbackProxy"),
                .target(name: "Model"),
                .target(name: "Interface"),
                .target(name: "Callbacker")
            ],
            path: "OpenIMSDK",
            exclude: ["LICENSE"],
            sources: ["OpenIMSDK.{h,m}"],
            publicHeadersPath: ".",
            cSettings: [
                .define("VALID_ARCHS", to: "armv7s arm64 x86_64")
            ]
        ),
        .target(
            name: "Utils",
            path: "OpenIMSDK/Utils",
            sources: ["*.{h,m}"]
        ),
        .target(
            name: "CallbackProxy",
            dependencies: ["Utils"],
            path: "OpenIMSDK/CallbackProxy",
            sources: ["*.{h,m}"]
        ),
        .target(
            name: "Model",
            dependencies: ["Utils"],
            path: "OpenIMSDK/Model",
            sources: ["*.{h,m}"]
        ),
        .target(
            name: "Interface",
            dependencies: ["Model", "CallbackProxy", "Callbacker"],
            path: "OpenIMSDK/Interface",
            sources: ["*.{h,m}"]
        ),
        .target(
            name: "Callbacker",
            dependencies: ["Model", "Utils"],
            path: "OpenIMSDK/Callbacker",
            sources: ["*.{h,m}"]
        )
    ]
)