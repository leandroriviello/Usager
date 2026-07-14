// swift-tools-version: 6.2
import Foundation
import PackageDescription

let sweetCookieKitPath = "../SweetCookieKit"
let useRawResourceCopy = ProcessInfo.processInfo.environment["USAGER_RAW_RESOURCES"] == "1"
let useLocalSweetCookieKit =
    ProcessInfo.processInfo.environment["USAGER_USE_LOCAL_SWEETCOOKIEKIT"] == "1"
let sweetCookieKitDependency: Package.Dependency =
    useLocalSweetCookieKit && FileManager.default.fileExists(atPath: sweetCookieKitPath)
    ? .package(path: sweetCookieKitPath)
    : .package(url: "https://github.com/steipete/SweetCookieKit", from: "0.4.1")

let sqlite3LibDir = ProcessInfo.processInfo.environment["USAGER_SQLITE3_LIB_DIR"]?
    .trimmingCharacters(in: .whitespacesAndNewlines)
let sqlite3LinkerSettings: [LinkerSetting] = if let sqlite3LibDir, !sqlite3LibDir.isEmpty {
    [.unsafeFlags(["-L\(sqlite3LibDir)"], .when(platforms: [.linux]))]
} else {
    []
}

let package = Package(
    name: "Usager",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
    ],
    products: {
        var products: [Product] = [
            .library(name: "UsagerCore", targets: ["UsagerCore"]),
            .executable(name: "UsagerCLI", targets: ["UsagerCLI"]),
        ]

        #if os(macOS)
        products.append(contentsOf: [
            .executable(name: "Usager", targets: ["Usager"]),
            .executable(name: "UsagerClaudeWatchdog", targets: ["UsagerClaudeWatchdog"]),
            .executable(name: "UsagerWidget", targets: ["UsagerWidget"]),
            .executable(name: "UsagerClaudeWebProbe", targets: ["UsagerClaudeWebProbe"]),
        ])
        #endif

        return products
    }(),
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.9.3"),
        .package(url: "https://github.com/steipete/Commander", from: "0.2.1"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.13.2"),
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", from: "2.4.0"),
        .package(url: "https://github.com/zats/Vortex", revision: "ef5392088d4aeb255c4eee83157dbdafcd31bf07"),
        sweetCookieKitDependency,
    ],
    targets: {
        var targets: [Target] = [
            // Host pkg-config paths contaminate cross-musl links; the module map supplies sqlite3 linkage.
            .systemLibrary(
                name: "CSQLite3",
                providers: [
                    .apt(["libsqlite3-dev"]),
                    .brew(["sqlite3"]),
                ]),
            .target(
                name: "UsagerCore",
                dependencies: [
                    .target(name: "CSQLite3", condition: .when(platforms: [.linux])),
                    .product(name: "Crypto", package: "swift-crypto"),
                    .product(name: "Logging", package: "swift-log"),
                    .product(name: "SweetCookieKit", package: "SweetCookieKit"),
                ],
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency"),
                ],
                linkerSettings: sqlite3LinkerSettings),
            .executableTarget(
                name: "UsagerCLI",
                dependencies: [
                    "UsagerCore",
                    .product(name: "Commander", package: "Commander"),
                ],
                path: "Sources/UsagerCLI",
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency"),
                ],
                linkerSettings: sqlite3LinkerSettings),
            .testTarget(
                name: "UsagerLinuxTests",
                dependencies: [
                    "UsagerCore",
                    "UsagerCLI",
                    .target(name: "CSQLite3", condition: .when(platforms: [.linux])),
                ],
                path: "TestsLinux",
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency"),
                    .enableExperimentalFeature("SwiftTesting"),
                ]),
        ]

        #if os(macOS)
        targets.append(contentsOf: [
            .executableTarget(
                name: "UsagerClaudeWatchdog",
                dependencies: [],
                path: "Sources/UsagerClaudeWatchdog",
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency"),
                ]),
            .executableTarget(
                name: "Usager",
                dependencies: [
                    .product(name: "Sparkle", package: "Sparkle"),
                    .product(name: "KeyboardShortcuts", package: "KeyboardShortcuts"),
                    .product(name: "Vortex", package: "Vortex"),
                    "UsagerCore",
                ],
                path: "Sources/Usager",
                resources: [
                    useRawResourceCopy ? .copy("Resources") : .process("Resources"),
                ],
                swiftSettings: [
                    // Opt into Swift 6 strict concurrency (approachable migration path).
                    .enableUpcomingFeature("StrictConcurrency"),
                    .define("ENABLE_SPARKLE"),
                ]),
            .executableTarget(
                name: "UsagerWidget",
                dependencies: ["UsagerCore"],
                path: "Sources/UsagerWidget",
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency"),
                ]),
            .executableTarget(
                name: "UsagerClaudeWebProbe",
                dependencies: ["UsagerCore"],
                path: "Sources/UsagerClaudeWebProbe",
                swiftSettings: [
                    .enableUpcomingFeature("StrictConcurrency"),
                ]),
        ])

        targets.append(.testTarget(
            name: "UsagerTests",
            dependencies: ["Usager", "UsagerCore", "UsagerCLI", "UsagerWidget"],
            path: "Tests",
            resources: [
                .copy("UsagerTests/Fixtures"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]))
        #endif

        return targets
    }())
