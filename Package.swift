// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Auth",
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
    ],
    dependencies: [
        // Swift Promises, Futures, and Streams.
        .package(url: "https://github.com/vapor/async.git", .exact("1.0.0-beta.1")),

        // Core extensions, type-aliases, and functions that facilitate common tasks.
        .package(url: "https://github.com/vapor/core.git", .exact("3.0.0-beta.1")),
        
        // Cryptography modules
        .package(url: "https://github.com/vapor/crypto.git", .exact("3.0.0-beta.1")),

        // Non-blocking networking for Swift (HTTP and WebSockets).
        .package(url: "https://github.com/vapor/engine.git", .exact("3.0.0-beta.1")),

        // Swift ORM (queries, models, and relations) for NoSQL and SQL databases.
        .package(url: "https://github.com/vapor/fluent.git", .exact("3.0.0-beta.1")),

        // Service container and configuration system.
        .package(url: "https://github.com/vapor/service.git", .exact("1.0.0-beta.1")),

        // A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .exact("3.0.0-beta.2")),
    ],
    targets: [
        .target(name: "Authentication", dependencies: ["Async", "Bits", "Crypto", "Debugging", "Fluent", "HTTP", "Service", "Vapor"]),
        .testTarget(name: "AuthenticationTests", dependencies: ["Authentication", "FluentSQLite", "Vapor"]),
    ]
)
