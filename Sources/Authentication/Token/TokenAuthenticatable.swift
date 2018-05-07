import Async
import Fluent
import Vapor

/// Authenticatable via a related token type.
public protocol TokenAuthenticatable: Authenticatable {
    /// The associated token type.
    associatedtype TokenType: Token
        where TokenType.UserType == Self


    /// Authenticates using the supplied token and connection.
    static func authenticate(
        token: TokenType,
        on connection: DatabaseConnectable
    ) -> Future<Self?>
}

extension TokenAuthenticatable where Self: Model, Self.Database: QuerySupporting {
    /// See `TokenAuthenticatable.authenticate(...)`
    public static func authenticate(
        token: TokenType,
        on connection: DatabaseConnectable
    ) -> Future<Self?> {
        return Future.flatMap(on: connection) {
            return try token.authUser.get(on: connection).map(to: Self?.self) { $0 }
        }
    }

}

/// A token, related to a user, capable of being used with Bearer auth.
/// See `TokenAuthenticatable`.
public protocol Token: BearerAuthenticatable, Model {
    /// The User type that owns this token.
    associatedtype UserType: Model
        where UserType.Database == Database

    /// Key path to the user ID
    typealias UserIDKey = WritableKeyPath<Self, UserType.ID>

    /// A relation to the user that owns this token.
    static var userIDKey: UserIDKey { get }
}

extension TokenAuthenticatable {
    /// A relation to this user's tokens.
    public var authTokens: Children<Self, TokenType> {
        return children(TokenType.userIDKey)
    }
}

extension Token {
    /// A relation to this token's owner.
    public var authUser: Parent<Self, UserType> {
        return parent(Self.userIDKey)
    }
}
