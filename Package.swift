// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "OnLaunch-iOS-Client",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "OnLaunch", targets: ["OnLaunch"]),
    ],
    targets: [
        .target(name: "OnLaunch"),
        .testTarget(name: "OnLaunchTests", dependencies: ["OnLaunch"]),
    ]
)
