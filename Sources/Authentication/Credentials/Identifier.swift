import Node

public struct Identifier {
    let id: Node

    public init(id: Node) {
        self.id = id
    }
}

extension User {
    public static func authenticate(_ id: Identifier) throws -> Self {
        guard let match = try Self.find(id.id) else {
            throw AuthenticationError.invalidCredentials
        }

        return match
    }
}
