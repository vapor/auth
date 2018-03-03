// swift-tools-version:4.0
import PackageDescription
import Foundation

let package = Package(
    name: "Auth",
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
    ],
    dependencies: [
        // 🌎 Utility package containing tools for byte manipulation, Codable, OS APIs, and debugging.
        .package(url: "https://github.com/vapor/core.git", .branch("nio")),
        
        // 🔑 Hashing (BCrypt, SHA, HMAC, etc), encryption, and randomness.
        .package(url: "https://github.com/vapor/crypto.git", .branch("nio")),

        // 🚀 Non-blocking, event-driven networking for Swift (HTTP and WebSockets).
        .package(url: "https://github.com/vapor/engine.git", .branch("nio")),

        // 🖋 Swift ORM framework (queries, models, and relations) for building NoSQL and SQL database integrations.
        .package(url: "https://github.com/vapor/fluent.git", .branch("nio")),

        // 📦 Dependency injection / inversion of control framework.
        .package(url: "https://github.com/vapor/service.git", .branch("nio")),

        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .branch("nio")),
    ],
    targets: [
        .target(name: "Authentication", dependencies: ["Async", "Bits", "Crypto", "Debugging", "Fluent", "HTTP", "Service", "Vapor"]),
    ]
)

if ProcessInfo.processInfo.environment["ENABLE_TESTS"]?.lowercased() == "true" {
    package.dependencies.append(.package(url: "https://github.com/vapor/fluent-sqlite.git", .branch("nio")))
    package.targets.append(.testTarget(name: "AuthenticationTests", dependencies: ["Authentication", "FluentSQLite", "Vapor"]))
}
