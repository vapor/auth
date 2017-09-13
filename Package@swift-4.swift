// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Auth",
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
        .library(name: "Authorization", targets: ["Authorization"]),
    ],
    dependencies: [
        // Swift models, relationships, and querying for NoSQL and SQL databases.
        .package(url: "https://github.com/vapor/fluent.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
    	.target(name: "Authentication", dependencies: ["Fluent"]),
    	.testTarget(name: "AuthenticationTests", dependencies: ["Authentication"]),
    	.target(name: "Authorization", dependencies: ["Authentication"]),
    ]
)
