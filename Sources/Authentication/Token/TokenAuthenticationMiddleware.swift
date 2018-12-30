/// Protects a route group, requiring a token authenticatable
/// instance to pass through.
///
/// use `req.requireAuthenticated(A.self)` to fetch the instance.
public final class TokenAuthenticationMiddleware<A>: Middleware where A: TokenAuthenticatable {
    /// The underlying bearer auth middleware.
    public let bearer: BearerAuthenticationMiddleware<A.TokenType>

    /// Create a new `TokenAuthenticationMiddleware`
    public init(bearer: BearerAuthenticationMiddleware<A.TokenType>) {
        self.bearer = bearer
    }

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        let responder = BasicResponder { req in
            guard let token = try req.authenticated(A.TokenType.self) else {
                return try next.respond(to: req)
            }
			
            return A.authenticate(token: token, on: req).flatMap { user in
                if let user = user {
                    try req.authenticate(user)
                }
                return try next.respond(to: req)
            }
        }
        return try bearer.respond(to: req, chainingTo: responder)
    }
}

extension TokenAuthenticatable where Self: Model {
    /// Creates a token auth middleware for this model.
    /// See `TokenAuthenticationMiddleware`.
    public static func tokenAuthMiddleware(database: DatabaseIdentifier<Database>? = nil) -> TokenAuthenticationMiddleware<Self> {
        return .init(bearer: TokenType.bearerAuthMiddleware())
    }
}
