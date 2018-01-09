import Async
import Fluent
import Vapor

/// Authenticatable via a related token type.
public protocol TokenAuthenticatable: Authenticatable {
    /// The associated token type.
    associatedtype TokenType: Token
        where TokenType.User == Self

    var tokens: Children<Self, TokenType> { get }
}

public protocol Token: BearerAuthenticatable {
    associatedtype User: Model
        where User.Database == Database

    var user: Parent<Self, User> { get }
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
            return token.user.get(on: req).flatMap(to: Response.self) { user in
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
