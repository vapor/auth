import Fluent
import Vapor

/// Protects a route group, requiring a token authenticatable
/// instance to pass through.
///
/// use `req.requireAuthenticated(A.self)` to fetch the instance.
public final class BearerAuthenticationMiddleware<A>: Middleware where A: BearerAuthenticatable {
    /// Creates a new `BearerAuthenticationMiddleware`.
    public init(_ type: A.Type = A.self) {}

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        // if the user has already been authenticated
        // by a previous middleware, continue
        if try req.isAuthenticated(A.self) {
            return try next.respond(to: req)
        }

        guard let token = req.http.headers.bearerAuthorization else {
            throw AuthenticationError(
                identifier: "invalidCredentials",
                reason: "Bearer authorization header required.",
                source: .capture()
            )
        }

        // auth user on connection
        return A.authenticate(
            using: token,
            on: req
        ).flatMap(to: Response.self) { a in
            guard let a = a else {
                throw Abort(.unauthorized, reason: "Invalid credentials")
            }

            // set authed on request
            try req.authenticate(a)
            return try next.respond(to: req)
        }
    }
}

extension BearerAuthenticatable {
    /// Creates a basic auth middleware for this model.
    /// See `BasicAuthenticationMiddleware`.
    public static func bearerAuthMiddleware() -> BearerAuthenticationMiddleware<Self> {
        return BearerAuthenticationMiddleware()
    }
}
