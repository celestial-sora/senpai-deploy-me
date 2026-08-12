// swift-tools-version: 5.6

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "SenpaiDeployMe",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "Senpai Deploy Me",
            targets: ["AppModule"],
            bundleIdentifier: "com.example.SenpaiDeployMe",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .gamepad),
            accentColor: .presetColor(.blue),
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
