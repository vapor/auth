// MARK: Data structure

public struct Token: Crendentials {
    public let string: String

    public init(string: String) {
        self.string = string
    }
}

// MARK: Authenticatable

public protocol TokenAuthenticatable: Authenticatable {
    /// The token entity that contains a foreign key
    /// pointer to the user table
    associatedtype TokenType: TokenProtocol

    /// Returns the user matching the supplied token.
    static func authenticate(_: Token) throws -> Self
}

public protocol TokenProtocol {
    static var tokenKey: String { get }
    static func findUser<U: Entity>(for: Token) throws -> U
}

extension TokenProtocol {
    public static var tokenKey: String {
        return "token"
    }
}

// MARK: Entity conformance

import Fluent

extension TokenAuthenticatable where Self: Entity {
    public static func authenticate(_ token: Token) throws -> Self {
        return try TokenType.findUser(for: token)
    }
}

extension TokenProtocol where Self: Entity {
    public static func findUser<U: Entity>(for token: Token) throws -> U {
        guard let user = try U.query()
            .join(self)
            .filter(self, tokenKey, token.string)
            .first()
        else {
            throw AuthenticationError.invalidCredentials
        }

        return user
    }
}
