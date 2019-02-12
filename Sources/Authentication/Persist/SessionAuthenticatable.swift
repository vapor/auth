/// Models conforming to this protocol can have their authentication
/// status cached using `AuthenticationSessionsMiddleware`.
public protocol SessionAuthenticatable: Authenticatable {
    /// Session identifier type.
    associatedtype SessionID: LosslessStringConvertible

    /// Unique session identifier.
    var sessionID: SessionID? { get }

    /// Authenticate a model with the supplied ID.
    static func authenticate(sessionID: SessionID, on connection: DatabaseConnectable) -> Future<Self?>
}

extension Model where Self: SessionAuthenticatable, Self.ID: LosslessStringConvertible, Self.Database: QuerySupporting {
    /// See `SessionAuthenticatable`.
    public typealias SessionID = Self.ID

    /// See `SessionAuthenticatable`.
    public var sessionID: Self.ID? {
        return fluentID
    }

    /// See `SessionAuthenticatable`.
    public static func authenticate(sessionID: Self.ID, on conn: DatabaseConnectable) -> Future<Self?> {
        return find(sessionID, on: conn)
    }
}

private extension SessionAuthenticatable {
    static var sessionName: String {
        return "\(Self.self)"
    }
}

extension Request {
    /// Authenticates the model into the session.
    public func authenticateSession<A>(_ a: A) throws where A: SessionAuthenticatable {
        try session()["_" + A.sessionName + "Session"] = a.sessionID?.description
        try authenticate(a)
    }

    /// Un-authenticates the model from the session.
    public func unauthenticateSession<A>(_ a: A.Type) throws where A: SessionAuthenticatable {
        guard try self.hasSession() else {
            return
        }
        try session()["_" + A.sessionName + "Session"] = nil
        try unauthenticate(A.self)
    }

    /// Returns the authenticatable type's ID if it exists
    /// in the session data.
    public func authenticatedSession<A>(_ a: A.Type) throws -> A.SessionID? where A: SessionAuthenticatable {
        return try session()["_" + A.sessionName + "Session"].flatMap { A.SessionID.init($0) }
    }
}
