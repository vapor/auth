import Async
import Bits
import Fluent

/// Authenticatable by `Bearer token` auth.
public protocol BearerAuthenticatable: Authenticatable {
    /// Key path to the token
    typealias TokenKey = WritableKeyPath<Self, String>

    /// The key under which the model's unique token is stored.
    static var tokenKey: TokenKey { get }

    /// Authenticates using the supplied credentials and connection.
    static func authenticate(using bearer: BearerAuthorization, on connection: DatabaseConnectable) -> Future<Self?>
}

extension BearerAuthenticatable where Self: Model, Self.Database: QuerySupporting {
    /// See `BearerAuthenticatable`.
    public static func authenticate(using bearer: BearerAuthorization, on conn: DatabaseConnectable) -> Future<Self?> {
        do {
            return try Self.query(on: conn).filter(tokenKey == bearer.token).first()
        } catch {
            return conn.eventLoop.newFailedFuture(error: error)
        }
    }
}

extension BearerAuthenticatable {
    /// Accesses the model's token
    public var bearerToken: String {
        get { return self[keyPath: Self.tokenKey] }
        set { self[keyPath: Self.tokenKey] = newValue }
    }
}
