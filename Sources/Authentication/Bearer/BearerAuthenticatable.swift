import Async
import Bits
import Fluent

/// Authenticatable by `Bearer token` auth.
public protocol BearerAuthenticatable: Authenticatable {
    /// Key path to the tokeen
    typealias TokenKey = ReferenceWritableKeyPath<Self, String>

    /// The key under which the user's username,
    /// email, or other identifing value is stored.
    static var tokenKey: TokenKey { get }
}

extension BearerAuthenticatable {
    /// Accesses the model's token
    public var bearerToken: String {
        get { return self[keyPath: Self.tokenKey] }
        set { self[keyPath: Self.tokenKey] = newValue }
    }
}
