import Async
import Bits
import Fluent

extension BearerAuthorization: HeaderAuthorization {}

/// Authenticatable by `Bearer token` auth.
public protocol BearerAuthenticatable: HeaderAuthenticatable where AuthorizationType == BearerAuthorization {
}

extension HeaderAuthenticatable where AuthorizationType == BearerAuthorization {
    /// Accesses the model's token
    public var bearerToken: String {
        get { return authToken }
        set { authToken = newValue }
    }

	/// See `HeaderAuthenticatable`
	/// Pulls an authorization token out of the headers.
	public static func authorization(from headers: HTTPHeaders) -> AuthorizationType? {
		return headers.bearerAuthorization
	}
}
