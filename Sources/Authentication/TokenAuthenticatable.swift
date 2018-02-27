import Async
import Fluent
import Vapor

/// Authenticatable via a related token type.
public protocol TokenAuthenticatable: Authenticatable {
    /// The associated token type.
    associatedtype TokenType: Token
        where TokenType.UserType == Self
}

/// A token, related to a user, capable of being used with Bearer auth.
/// See `TokenAuthenticatable`.
public protocol Token: BearerAuthenticatable {
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

/// Protects a route group, requiring a password authenticatable
/// instance to pass through.
///
/// use `req.requireAuthenticated(A.self)` to fetch the instance.
public final class TokenAuthenticationMiddleware<A>: Middleware
    where A: TokenAuthenticatable, A.Database: QuerySupporting
{
    /// The underlying bearer auth middleware.
    public let bearer: BearerAuthenticationMiddleware<A.TokenType>

    /// Create a new `TokenAuthenticationMiddleware`
    public init(bearer: BearerAuthenticationMiddleware<A.TokenType>) {
        self.bearer = bearer
    }

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        let responder = BasicResponder { req in
            let token = try req.requireAuthenticated(A.TokenType.self)
            return token.authUser.get(on: req).flatMap(to: Response.self) { user in
                try req.authenticate(user)
                return try next.respond(to: req)
            }
        }
        return try bearer.respond(to: req, chainingTo: responder)
    }
}

extension TokenAuthenticatable where Database: QuerySupporting {
    /// Creates a basic auth middleware for this model.
    /// See `BasicAuthenticationMiddleware`.
    public static func tokenAuthMiddleware(
        database: DatabaseIdentifier<Database>? = nil
    ) throws -> TokenAuthenticationMiddleware<Self> {
        return try .init(
            bearer: TokenType.bearerAuthMiddleware(
                database: database ?? Self.requireDefaultDatabase()
            )
        )
    }
}
