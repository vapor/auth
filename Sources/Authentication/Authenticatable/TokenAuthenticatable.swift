public protocol TokenAuthenticatable: Authenticatable {
    /// The token entity that contains a foreign key
    /// pointer to the user table (or on the user table itself)
    associatedtype TokenType
    
    /// Returns the user matching the supplied token.
    static func authenticate(_ token: Token) throws -> Self
    
    /// The column under which the tokens are stored
    static var tokenKey: String { get }
}

extension TokenAuthenticatable {
    public static var tokenKey: String {
        return "token"
    }
}

// MARK: Entity conformance

import Fluent

extension TokenAuthenticatable where Self: Entity, Self.TokenType: Entity {
    public static func authenticate(_ token: Token) throws -> Self {
        guard let user = try Self.makeQuery()
            .join(Self.TokenType.self)
            .filter(Self.TokenType.self, tokenKey, token.string)
            .first()
            else {
                throw AuthenticationError.invalidCredentials
        }
        
        return user
    }
}

extension TokenAuthenticatable where Self: Entity, Self.TokenType: Entity, Self.TokenType == Self {
    public static func authenticate(_ token: Token) throws -> Self {
        guard let user = try Self.makeQuery()
            .filter(tokenKey, token.string)
            .first()
            else {
                throw AuthenticationError.invalidCredentials
        }
        
        return user
    }
}
