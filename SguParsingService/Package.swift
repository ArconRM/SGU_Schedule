// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SguParsingService",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // 📚 Local parser package.
        .package(name: "SguParser", path: "../SguParser"),
    ],
    targets: [
        .executableTarget(
            name: "SguParsingService",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "SguParser", package: "SguParser"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SguParsingServiceTests",
            dependencies: [
                .target(name: "SguParsingService"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
