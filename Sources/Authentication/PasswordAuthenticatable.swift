import Async
import Fluent
import Service
import Vapor

/// Authenticatable using a username and password.
public protocol PasswordAuthenticatable: BasicAuthenticatable { }

extension PasswordAuthenticatable where Database: QuerySupporting {
    /// Authenticates using a username and password on the supplied connection.
    public static func authenticate(
        username: String,
        password: String,
        on worker: DatabaseConnectable & Container
    ) -> Future<Self?> {
        return Future<Self?>.flatMap {
            return try Self.authenticate(
                using: .init(username: username, password: password),
                verifier: worker.make(PasswordVerifier.self, for: Self.self),
                on: worker
            )
        }
    }
}
