import PackageDescription

let package = Package(
    name: "Auth",
    targets: [
        Target(name: "Authentication"),
        Target(name: "Authorization", dependencies: ["Authentication"]),
    ],
    dependencies: [
        // Swift models, relationships, and querying for NoSQL and SQL databases.
        .Package(url: "https://github.com/vapor/fluent.git", majorVersion: 2)
    ]
)
