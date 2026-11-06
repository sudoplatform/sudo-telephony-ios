// swift-tools-version: 6.0
//
// Copyright © 2026 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import PackageDescription

// PLATFORM DEPENDENCIES
// ---------------------
// The SDK links the real Sudo Platform transport stack: `sudo-api-client-ios`
// (AppSync GraphQL over Amplify), `sudo-user-ios`, `sudo-config-manager-ios`,
// `sudo-logging-ios`, `sudo-key-manager-ios`, and `amplify-swift`. The generated
// Apollo operations (`Source/Internal/Data/GraphQLAPI.swift`) conform to
// `SudoApiClient`'s GraphQL protocols, so the data layer talks to AppSync directly.
//
// Because these are iOS-only and build against Amplify/AWS, the package does not
// build with a plain host `swift build`. Build and test on an iOS Simulator with
// `xcodebuild -workspace .swiftpm/xcode/package.xcworkspace -scheme SudoTelephony-Package`.

let package = Package(
    name: "SudoTelephony",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SudoTelephony",
            targets: ["SudoTelephony"]
        ),
        .library(
            name: "SudoTelephonyCommon",
            targets: ["SudoTelephonyCommon"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/sudoplatform/sudo-api-client-ios", from: "14.0.0"),
        .package(url: "https://github.com/sudoplatform/sudo-config-manager-ios", from: "6.0.1"),
        .package(url: "https://github.com/sudoplatform/sudo-user-ios", from: "19.0.0"),
        .package(url: "https://github.com/sudoplatform/sudo-logging-ios", from: "3.0.0"),
        .package(url: "https://github.com/sudoplatform/sudo-key-manager-ios", from: "5.0.0"),
        // Pinned to match the reference SDKs' resolved graph (sudo-privacy-interaction
        // v2.1). Newer Amplify / AWS-SDK / Apple releases transitively pull package
        // versions that require a Swift 6.2+ toolchain; CI runs Swift 6.1, so these
        // upper bounds keep the resolved graph buildable there. Revisit when CI's Xcode
        // is bumped.
        .package(url: "https://github.com/aws-amplify/amplify-swift", "2.49.1" ..< "2.61.0"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", "1.0.0" ..< "1.7.54"),
        .package(url: "https://github.com/smithy-lang/smithy-swift", "0.0.0" ..< "0.239.0"),
        .package(url: "https://github.com/apple/swift-collections.git", "1.0.0" ..< "1.7.0"),
        .package(url: "https://github.com/apple/swift-log.git", "1.0.0" ..< "1.16.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", "2.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle", "2.0.0" ..< "2.13.0"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", "1.0.0" ..< "1.5.0")
    ],
    targets: [
        .target(
            name: "SudoTelephonyCommon",
            dependencies: [
                .product(name: "SudoLogging", package: "sudo-logging-ios"),
                .product(name: "SudoKeyManager", package: "sudo-key-manager-ios")
            ],
            path: "SudoTelephonyCommon/Source",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "SudoTelephony",
            dependencies: [
                "SudoTelephonyCommon",
                .product(name: "Amplify", package: "amplify-swift"),
                .product(name: "AWSPluginsCore", package: "amplify-swift"),
                .product(name: "SudoApiClient", package: "sudo-api-client-ios"),
                .product(name: "SudoConfigManager", package: "sudo-config-manager-ios"),
                .product(name: "SudoUser", package: "sudo-user-ios"),
                .product(name: "SudoLogging", package: "sudo-logging-ios"),
                .product(name: "SudoKeyManager", package: "sudo-key-manager-ios")
            ],
            path: "SudoTelephony/Source",
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
        // The unit tests are internal: they run through SudoTelephony.xcodeproj and aren't published.
    ]
)
