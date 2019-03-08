import Async
import Bits
import Fluent

/// Authenticatable by `Bearer token` auth.
public protocol BearerAuthenticatable: HeaderValueAuthenticatable {}

extension BearerAuthenticatable {
    /// Accesses the model's token
    public var bearerToken: String {
        get { return authToken }
        set { authToken = newValue }
    }

    /// See `HeaderAuthenticatable`
    /// Pulls an authorization token out of the headers.
    public static func authToken(from headers: HTTPHeaders) -> String? {
        return headers.bearerAuthorization?.token
    }
}
