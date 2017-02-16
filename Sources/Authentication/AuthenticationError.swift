public enum AuthenticationError: Swift.Error {
    case invalidBasicAuthorization
    case invalidBearerAuthorization
    case noAuthorizationHeader
    case notAuthenticated
    case invalidCredentials
    case unsupportedCredentials
    case unspecified(Error)
}

extension AuthenticationError: CustomStringConvertible {
    public var description: String {
        let reason: String

        switch self {
        case .invalidBasicAuthorization:
            reason = "Invalid Authorization Basic header"
        case .invalidBearerAuthorization:
            reason = "Invalid Authorization Bearer header"
        case .noAuthorizationHeader:
            reason = "No authorization header"
        case .notAuthenticated:
            reason = "Not authenticated"
        case .invalidCredentials:
            reason = "Invalid credentials"
        case .unsupportedCredentials:
            reason = "Unsupported credentials"
        case .unspecified(let error):
            reason = "\(error)"
        }

        return "Authentication error: \(reason)"
    }
}

