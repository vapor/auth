import Async
import Fluent
import Service
import Vapor

/// Authenticatable using a username and password.
public protocol PasswordAuthenticatable: BasicAuthenticatable { }

extension PasswordAuthenticatable where Database: QuerySupporting {
    /// Authenticates using a username and password using the supplied
    // verifier on the supplied connection.
    public static func authenticate(
        username: String,
        password: String,
        using verifier: PasswordVerifier,
        on worker: DatabaseConnectable
    ) -> Future<Self?> {
        return Future<Self?>.flatMap {
            return Self.authenticate(
                using: .init(username: username, password: password),
                verifier: verifier,
                on: worker
            )
        }
    }
}
