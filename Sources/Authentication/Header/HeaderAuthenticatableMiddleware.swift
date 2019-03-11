
/// Protects a route group, requiring a token authenticatable
/// instance to pass through.
///
/// use `req.requireAuthenticated(A.self)` to fetch the instance.
public class HeaderValueAuthenticationMiddleware<A>: Middleware where A: HeaderValueAuthenticatable {
    /// Creates a new `HeaderAuthenticationMiddleware`.
    public init(_ type: A.Type = A.self) {}

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        // if the user has already been authenticated
        // by a previous middleware, continue
        if try req.isAuthenticated(A.self) {
            return try next.respond(to: req)
        }

        guard let token = A.authToken(from: req.http.headers) else {
            return try next.respond(to: req)
        }

        // auth user on connection
        return A.authenticate(using: token, on: req).flatMap { a in
            if let a = a {
                // set authed on request
                try req.authenticate(a)
            }

            return try next.respond(to: req)
        }
    }
}

extension HeaderValueAuthenticatable {
    /// Creates a header auth middleware for this model.
    /// See `HeaderValueAuthenticationMiddleware`.
    public static func headerAuthMiddleware() -> HeaderValueAuthenticationMiddleware<Self> {
        return HeaderValueAuthenticationMiddleware()
    }
}
