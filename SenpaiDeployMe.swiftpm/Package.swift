// swift-tools-version: 5.6

import PackageDescription

#if canImport(AppleProductTypes)
import AppleProductTypes

let package = Package(
    name: "Senpai Deploy Me",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Senpai Deploy Me",
            targets: ["AppModule"],
            bundleIdentifier: "com.example.SenpaiDeployMe",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .gamepad),
            accentColor: .presetColor(.indigo),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
#else
let package = Package(
    name: "Senpai Deploy Me",
    platforms: [
        .macOS("13.0"),
        .iOS("16.0")
    ],
    products: [
        .executable(
            name: "SenpaiDeployMe",
            targets: ["AppModule"]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
#endif