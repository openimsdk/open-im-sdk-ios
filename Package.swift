// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OpenIMSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "OpenIMSDK", targets: ["OpenIMSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/CoderMJLee/MJExtension.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "OpenIMSDK",
            dependencies: [
                "OpenIMSDKCore",
                "MJExtension",
            ],
            path: "OpenIMSDK",
            sources: ["OpenIMSDK.h"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath(".")
            ]
        ),
        .target(
            name: "OpenIMSDKUtils",
            dependencies: [],
            path: "OpenIMSDK/Utils"
        ),
        .target(
            name: "OpenIMSDKCallbackProxy",
            dependencies: ["OpenIMSDKUtils"],
            path: "OpenIMSDK/CallbackProxy"
        ),
        .target(
            name: "OpenIMSDKModel",
            dependencies: ["OpenIMSDKUtils"],
            path: "OpenIMSDK/Model"
        ),
        .target(
            name: "OpenIMSDKCallbacker",
            dependencies: [
                "OpenIMSDKModel",
                "OpenIMSDKUtils",
            ],
            path: "OpenIMSDK/Callbacker"
        ),
        .target(
            name: "OpenIMSDKInterface",
            dependencies: [
                "OpenIMSDKModel",
                "OpenIMSDKCallbackProxy",
                "OpenIMSDKCallbacker",
            ],
            path: "OpenIMSDK/Interface"
        ),
    ],
    cxxLanguageStandard: .cxx14
)
