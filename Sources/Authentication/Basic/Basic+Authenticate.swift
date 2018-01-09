import Async
import Fluent

extension BasicAuthenticatable where Database: QuerySupporting {
    /// Authenticates using the supplied credentials, connection, and verifier.
    public static func authenticate(
        using password: BasicAuthorization,
        verifier: PasswordVerifier,
        on connection: DatabaseConnectable
    ) -> Future<Self?> {
        return Self
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
                matches: user.basicPassword
            ) else {
                return nil
            }

            return user
        }
    }
}

