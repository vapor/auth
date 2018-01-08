import Async
import Fluent

extension PasswordAuthenticatable where Database: QuerySupporting {
    /// Authenticates using the supplied credentials, connection, and verifier.
    public static func authenticate(
        using password: Password,
        verifier: PasswordVerifier,
        on connection: DatabaseConnectable
    ) -> Future<Self?> {
        return try! Self
            .query(on: connection)
            .filter(usernameKey == password.username)
            .first()
            .map(to: Self?.self)
        { user in
            guard let user = user else {
                return nil
            }

            guard try verifier.verify(
                password: password.password,
                matches: user.authPassword
            ) else {
                return nil
            }

            return user
        }
    }
}

