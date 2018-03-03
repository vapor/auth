import Fluent
import Vapor

/// Models conforming to this protocol can have their authentication
/// status cached using `AuthenticationSessionsMiddleware`.
public protocol SessionAuthenticatable: Authenticatable {
    /// Create a serializable String representation for this model's ID.
    func makeSessionID() throws -> String

    /// Convert the serializable String representation for this model's ID
    /// back into native ID format.
    static func makeID(fromSessionID string: String) throws -> ID

    /// Authenticate a model with the supplied ID.
    static func authenticate(id: ID, on connection: DatabaseConnectable) -> Future<Self?>
}

extension SessionAuthenticatable where Self.ID: StringConvertible {
    /// See `SessionAuthenticatable.makeSessionID()`
    public func makeSessionID() throws -> String {
        return try requireID().convertToString()
    }

    /// See `SessionAuthenticatable.makeID(fromSessionID:)`
    public static func makeID(fromSessionID string: String) throws -> ID {
        return try ID.convertFromString(string)
    }
}

extension SessionAuthenticatable where Self.Database: QuerySupporting {
    /// See `SessionAuthenticatable.authenticate(id:on:)`
    public static func authenticate(id: ID, on connection: DatabaseConnectable) -> Future<Self?> {
        return find(id, on: connection)
    }
}

extension Request {
    /// Authenticates the model into the session.
    public func authenticateSession<A>(_ a: A) throws where A: SessionAuthenticatable {
        try session()["_" + A.name + "Session"] = try a.makeSessionID()
    }

    /// Un-authenticates the model from the session.
    public func unauthenticateSession<A>(_ a: A.Type) throws where A: SessionAuthenticatable {
        try session()["_" + A.name + "Session"] = nil
    }

    /// Returns the authenticatable type's ID if it exists
    /// in the session data.
    public func authenticatedSession<A>(_ a: A.Type) throws -> A.ID? where A: SessionAuthenticatable {
        guard let idString = try session()["_" + A.name + "Session"] else {
            return nil
        }
        return try A.makeID(fromSessionID: idString)
    }
}
