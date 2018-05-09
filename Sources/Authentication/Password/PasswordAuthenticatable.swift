import Async
import Fluent
import Service
import Vapor

/// Authenticatable using a username and password.
public protocol PasswordAuthenticatable: BasicAuthenticatable {
    /// Authenticates using a username and password using the supplied
    /// verifier on the supplied connection.
    static func authenticate(username: String, password: String, using verifier: PasswordVerifier, on conn: DatabaseConnectable) -> Future<Self?>
}

extension PasswordAuthenticatable where Self: Model, Self.Database: QuerySupporting {
    /// See `PasswordAuthenticatable`
    public static func authenticate(username: String, password: String, using verifier: PasswordVerifier, on conn: DatabaseConnectable ) -> Future<Self?> {
        return authenticate(
            using: .init(username: username, password: password),
            verifier: verifier,
            on: conn
        )
    }
}
