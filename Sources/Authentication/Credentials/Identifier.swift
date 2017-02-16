// MARK: Data structure

import Node

public struct Identifier: Crendentials {
    let id: Node

    public init(id: Node) {
        self.id = id
    }
}

// MARK: Authenticatable

public protocol IdentifierAuthenticatable {
    /// Return the user with the supplied id.
    static func authenticate(_: Identifier) throws -> Self
}


// MARK: Entity conformance

import Fluent

extension IdentifierAuthenticatable where Self: Entity {
    public static func authenticate(_ id: Identifier) throws -> Self {
        guard let match = try Self.find(id.id) else {
            throw AuthenticationError.invalidCredentials
        }

        return match
    }
}
