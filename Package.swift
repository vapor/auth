// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "auth",
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
    ],
    dependencies: [
        // 🔑 Hashing (BCrypt, SHA, HMAC, etc), encryption, and randomness.
        .package(url: "https://github.com/vapor/crypto.git", .branch("master")),
        
        // 🖋 Swift ORM framework (queries, models, and relations) for building NoSQL and SQL database integrations.
        .package(url: "https://github.com/vapor/fluent.git", .branch("master")),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", .branch("master")),
    ],
    targets: [
        .target(name: "Authentication", dependencies: ["Fluent", "Vapor"]),
        .testTarget(name: "AuthenticationTests", dependencies: ["Authentication", "Vapor"]),
    ]
)
