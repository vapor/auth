import PackageDescription

let package = Package(
    name: "Auth",
    targets: [
        Target(name: "Authentication"),
        Target(name: "Authorization", dependencies: ["Authentication"]),
    ],
    dependencies: [
        // Swift models, relationships, and querying for NoSQL and SQL databases.
        .Package(url: "https://github.com/vapor/fluent.git", Version(2,0,0, prereleaseIdentifiers: ["alpha"]))
    ]
)
