import Async
import Bits
import Fluent

extension BearerAuthorization: HeaderValueAuthorization {}

/// Authenticatable by `Bearer token` auth.
public protocol BearerAuthenticatable: HeaderValueAuthenticatable where AuthorizationValue == BearerAuthorization {
}

// This extension captures both things explicitly declared to be
// BearerAuthenticatable and also things declared to be
// HeaderValueAuthenticatable with an AuthorizationType of
// BearerAuthorization.
extension HeaderValueAuthenticatable where AuthorizationValue == BearerAuthorization {
    /// Accesses the model's token
    public var bearerToken: String {
        get { return authToken }
        set { authToken = newValue }
    }

    /// See `HeaderAuthenticatable`
    /// Pulls an authorization token out of the headers.
    public static func authorization(from headers: HTTPHeaders) -> AuthorizationValue? {
        return headers.bearerAuthorization
    }
}
