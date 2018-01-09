import Async
import Fluent

extension BearerAuthenticatable where Database: QuerySupporting {
    /// Authenticates using the supplied credentials and connection.
    public static func authenticate(
        using bearer: BearerAuthorization,
        on connection: DatabaseConnectable
    ) -> Future<Self?> {
        return Self
            .query(on: connection)
            .filter(tokenKey == bearer.token)
            .first()
    }
}
