// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Auth",
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
    ],
    dependencies: [
        // Swift Promises, Futures, and Streams.
        .package(url: "https://github.com/vapor/async.git", .branch("beta")),

        // Core extensions, type-aliases, and functions that facilitate common tasks.
        .package(url: "https://github.com/vapor/core.git", .branch("beta")),

        // Swift ORM (queries, models, and relations) for NoSQL and SQL databases.
        .package(url: "https://github.com/vapor/fluent.git", .branch("beta")),

        // Service container and configuration system.
        .package(url: "https://github.com/vapor/service.git", .branch("beta")),

        // A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .branch("beta")),
    ],
    targets: [
        .target(name: "Authentication", dependencies: ["Async", "Bits", "Crypto", "Debugging", "Fluent", "HTTP", "Service", "Vapor"]),
        .testTarget(name: "AuthenticationTests", dependencies: ["Authentication", "FluentSQLite", "Vapor"]),
    ]
)
