// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "AgenticRecovery",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "AgenticRecovery",
            targets: [
                "AgenticRecovery",
            ]
        ),
        .executable(
            name: "arecovtest",
            targets: [
                "AgenticRecoveryTestFlows",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/Primitives.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Errors.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Macros.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/TestFlows.git",
            branch: "master"
        ),
    ],
    targets: [
        .target(
            name: "AgenticRecovery",
            dependencies: [
                .product(
                    name: "Primitives",
                    package: "Primitives"
                ),
                .product(
                    name: "Errors",
                    package: "Errors"
                ),
                .product(
                    name: "Macros",
                    package: "Macros"
                ),
            ]
        ),
        .executableTarget(
            name: "AgenticRecoveryTestFlows",
            dependencies: [
                "AgenticRecovery",
                .product(
                    name: "Errors",
                    package: "Errors"
                ),
                .product(
                    name: "TestFlows",
                    package: "TestFlows"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [
        .v6,
    ]
)
