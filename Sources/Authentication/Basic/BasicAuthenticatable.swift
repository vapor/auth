import Async
import Bits
import Fluent

/// Authenticatable by `Basic username:password` auth.
public protocol BasicAuthenticatable: Authenticatable {
    /// Key path to the username
    typealias UsernameKey = WritableKeyPath<Self, String>

    /// The key under which the user's username,
    /// email, or other identifing value is stored.
    static var usernameKey: UsernameKey { get }

    /// Key path to the password
    typealias PasswordKey = WritableKeyPath<Self, String>

    /// The key under which the user's password
    /// is stored.
    static var passwordKey: PasswordKey { get }

    /// Authenticates using the supplied credentials, connection, and verifier.
    static func authenticate(
        using basic: BasicAuthorization,
        verifier: PasswordVerifier,
        on connection: DatabaseConnectable
    ) -> Future<Self?>
}

extension BasicAuthenticatable where Database: QuerySupporting {
    /// See `BasicAuthenticatable.authenticate(...)`
    public static func authenticate(
        using basic: BasicAuthorization,
        verifier: PasswordVerifier,
        on connection: DatabaseConnectable
    ) -> Future<Self?> {
        return Future.flatMap(on: connection) {
            return try Self
                .query(on: connection)
                .filter(usernameKey == basic.username)
                .first()
                .map(to: Self?.self)
            { user in
                guard let user = user else {
                    return nil
                }

                guard try verifier.verify(
                    password: basic.password,
                    matches: user.basicPassword
                    ) else {
                        return nil
                }

                return user
            }
        }
    }
}


extension BasicAuthenticatable {
    /// Accesses the model's password
    public var basicPassword: String {
        get { return self[keyPath: Self.passwordKey] }
        set { self[keyPath: Self.passwordKey] = newValue }
    }

    /// Accesses the model's username
    public var basicUsername: String {
        get { return self[keyPath: Self.usernameKey] }
        set { self[keyPath: Self.usernameKey] = newValue }
    }
}
