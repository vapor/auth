import Fluent
import Vapor

/// Persists authentication done by another auth middleware
/// allowing the authentication to only be passed once.
public final class AuthenticationSessionsMiddleware<A>: Middleware
    where A: Authenticatable, A.Database: QuerySupporting
{
    /// The database identifier
    public let database: DatabaseIdentifier<A.Database>

    /// create a new password auth middleware
    public init(
        authenticatable type: A.Type = A.self,
        database: DatabaseIdentifier<A.Database>
    ) {
        self.database = database
    }

    /// See Middleware.respond
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        let future: Future<Void>
        if let aID = try req.authenticatedSession(A.self) {
            // get database connection
            future = req.connect(to: database).flatMap(to: Void.self) { conn in
                // try to find user with id from session
                return A.find(aID, on: conn).flatMap(to: Void.self) { a in
                    // if the user was found, auth it
                    if let a = a {
                        try req.authenticate(a)
                    }

                    // return done
                    return .done
                }
            }
        } else {
            // no need to authenticate
            future = .done
        }

        // map the auth future to a resopnse
        return future.flatMap(to: Response.self) {
            // respond to the request
            return try next.respond(to: req).map(to: Response.self) { res in
                // if a user is authed, store in the session
                if let a = try req.authenticated(A.self) {
                    try req.authenticateSession(a)
                }
                return res
            }
        }
    }
}

extension Request {
    /// Authenticates the model into the session.
    public func authenticateSession<A>(_ a: A) throws where A: Authenticatable {
        try session().data.storage["_" + A.name + "Session"] = a.requireID()
    }

    /// Returns the authenticatable type's ID if it exists
    /// in the session data.
    public func authenticatedSession<A>(_ a: A.Type) throws -> A.ID? where A: Authenticatable  {
        return try session().data.storage["_" + A.name + "Session"] as? A.ID
    }
}

extension Authenticatable where Database: QuerySupporting {
    /// Create a `AuthenticationSessionsMiddleware` for this model.
    /// See `AuthenticationSessionsMiddleware`.
    public static func authSessionsMiddleware() throws -> AuthenticationSessionsMiddleware<Self> {
        return try .init(database: Self.requireDefaultDatabase())
    }
}
