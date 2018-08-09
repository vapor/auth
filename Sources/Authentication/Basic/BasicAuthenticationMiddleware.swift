/// Protects a route group, requiring a password authenticatable
/// instance to pass through.
///
/// use `req.requireAuthenticated(A.self)` to fetch the instance.
public final class BasicAuthenticationMiddleware<A>: Middleware where A: BasicAuthenticatable {
    /// the required password verifier
    public let verifier: PasswordVerifier

    /// create a new password auth middleware
    public init(authenticatable type: A.Type = A.self, verifier: PasswordVerifier) {
        self.verifier = verifier
    }

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        // if the user has already been authenticated
        // by a previous middleware, continue
        if try req.isAuthenticated(A.self) {
            return try next.respond(to: req)
        }

        // not pre-authed, check for auth data
        guard let password = req.http.headers.basicAuthorization else {
            return try next.respond(to: req)
        }

        // auth user on connection
        return A.authenticate(using: password, verifier: verifier, on: req).flatMap { a in
            if let a = a {
                // set authed on request
                try req.authenticate(a)
            }
            return try next.respond(to: req)
        }
    }
}

extension BasicAuthenticatable where Self: Model {
    /// Creates a basic auth middleware for this model.
    /// See `BasicAuthenticationMiddleware`.
    public static func basicAuthMiddleware(using verifier: PasswordVerifier) -> BasicAuthenticationMiddleware<Self> {
        return BasicAuthenticationMiddleware(verifier: verifier)
    }
}
