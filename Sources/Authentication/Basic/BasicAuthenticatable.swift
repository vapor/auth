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
    static func authenticate(using basic: BasicAuthorization, verifier: PasswordVerifier, on connection: DatabaseConnectable) -> Future<Self?>
}

extension BasicAuthenticatable where Self: Model {
    /// See `BasicAuthenticatable`.
    public static func authenticate(using basic: BasicAuthorization, verifier: PasswordVerifier, on conn: DatabaseConnectable) -> Future<Self?> {
        return Self.query(on: conn).filter(usernameKey == basic.username).first().map(to: Self?.self) { user in
            guard let user = user, try verifier.verify(basic.password, created: user.basicPassword) else {
                return nil
            }

            return user
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
