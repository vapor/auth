import Async
import Bits
import Fluent

/// Authenticatable by `Bearer token` auth.
public protocol BearerAuthenticatable: Authenticatable {
    /// Key path to the token
    typealias TokenKey = ReferenceWritableKeyPath<Self, String>

    /// The key under which the model's unique token is stored.
    static var tokenKey: TokenKey { get }
}

extension BearerAuthenticatable {
    /// Accesses the model's token
    public var bearerToken: String {
        get { return self[keyPath: Self.tokenKey] }
        set { self[keyPath: Self.tokenKey] = newValue }
    }
}
