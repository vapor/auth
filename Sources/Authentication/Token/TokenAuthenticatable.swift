/// Authenticatable via a related token type.
public protocol TokenAuthenticatable: Authenticatable {
    /// The associated token type.
    associatedtype TokenType: Token where
        TokenType.UserType == Self

    /// Authenticates using the supplied token and connection.
    static func authenticate(token: TokenType, on connection: DatabaseConnectable) -> Future<Self?>
}

/// A token, related to a user, capable of being used with Bearer auth.
/// See `TokenAuthenticatable`.
public protocol Token: HeaderValueAuthenticatable  {
    /// The User type that owns this token.
    associatedtype UserType

    /// Type of the User's ID
    associatedtype UserIDType

    /// Key path to the user ID
    typealias UserIDKey = WritableKeyPath<Self, UserIDType>

    /// A relation to the user that owns this token.
    static var userIDKey: UserIDKey { get }
}

extension Model where Self: Token, Self.UserType: Model {
    /// See `Token`.
    public typealias UserIDType = UserType.ID
}

extension TokenAuthenticatable
    where Self: Model, Self.TokenType: Model, Self.TokenType.Database == Self.Database, Self.TokenType.UserIDType == Self.ID
{
    /// See `TokenAuthenticatable`.
    public static func authenticate(token: TokenType, on conn: DatabaseConnectable) -> Future<Self?> {
        return token.authUser.get(on: conn).map { $0 }
    }

    /// A relation to this user's tokens.
    public var authTokens: Children<Self, TokenType> {
        return children(TokenType.userIDKey)
    }
}

extension Token
    where Self: Model, Self.UserType: Model, Self.UserType.Database == Self.Database, Self.UserIDType == Self.UserType.ID
{
    /// A relation to this token's owner.
    public var authUser: Parent<Self, UserType> {
        return parent(Self.userIDKey)
    }
}
