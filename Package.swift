// swift-tools-version:4.0
import PackageDescription
import Foundation

let package = Package(
    name: "Auth",
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
    ],
    dependencies: [
        // ⏱ Promises and reactive-streams in Swift built for high-performance and scalability.
        .package(url: "https://github.com/vapor/async.git", from: "1.0.0-rc"),

        // 🌎 Utility package containing tools for byte manipulation, Codable, OS APIs, and debugging.
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0-rc"),
        
        // 🔑 Hashing (BCrypt, SHA, HMAC, etc), encryption, and randomness.
        .package(url: "https://github.com/vapor/crypto.git", from: "3.0.0-rc"),

        // 🚀 Non-blocking, event-driven networking for Swift (HTTP and WebSockets).
        .package(url: "https://github.com/vapor/engine.git", from: "3.0.0-rc"),

        // 🖋 Swift ORM framework (queries, models, and relations) for building NoSQL and SQL database integrations.
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0-rc"),

        // 📦 Dependency injection / inversion of control framework.
        .package(url: "https://github.com/vapor/service.git", from: "1.0.0-rc"),

        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),
    ],
    targets: [
        .target(name: "Authentication", dependencies: ["Async", "Bits", "Crypto", "Debugging", "Fluent", "HTTP", "Service", "Vapor"]),
    ]
)

if ProcessInfo.processInfo.environment["ENABLE_TESTS"]?.lowercased() == "true" {
    package.dependencies.append(.package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc"))
    package.targets.append(.testTarget(name: "AuthenticationTests", dependencies: ["Authentication", "FluentSQLite", "Vapor"]))
}
