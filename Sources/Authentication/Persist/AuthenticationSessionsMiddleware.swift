/// Persists authentication done by another auth middleware allowing the authentication to only be passed once.
public final class AuthenticationSessionsMiddleware<A>: Middleware where A: SessionAuthenticatable {
    /// create a new password auth middleware
    public init(authenticatable type: A.Type = A.self) { }

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        let future: Future<Void>
        if let aID = try req.authenticatedSession(A.self) {
            // try to find user with id from session
            future = A.authenticate(sessionID: aID, on: req).flatMap { a in
                // if the user was found, auth it
                if let a = a {
                    try req.authenticate(a)
                }

                // return done
                return .done(on: req)
            }
        } else {
            // no need to authenticate
            future = .done(on: req)
        }

        // map the auth future to a resopnse
        return future.flatMap {
            // respond to the request
            return try next.respond(to: req).map { res in
                if let a = try req.authenticated(A.self) {
                    // if a user has been authed (or is still authed), store in the session
                    try req.authenticateSession(a)
                } else {
                    // if no user is authed, it's possible they've been unauthed.
                    // remove from session.
                    try req.unauthenticateSession(A.self)
                }
                return res
            }
        }
    }
}

extension SessionAuthenticatable {
    /// Create a `AuthenticationSessionsMiddleware` for this model.
    /// See `AuthenticationSessionsMiddleware`.
    public static func authSessionsMiddleware() -> AuthenticationSessionsMiddleware<Self> {
        return .init()
    }
}
