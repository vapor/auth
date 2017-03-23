import Debugging

public enum AuthenticationError: Error {
    case invalidBasicAuthorization
    case invalidBearerAuthorization
    case noAuthorizationHeader
    case notAuthenticated
    case invalidCredentials
    case unsupportedCredentials
    case unspecified(Error)
}

extension AuthenticationError: Debuggable {
    public var reason: String {
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
    
    public var identifier: String {
        switch self {
        case .invalidBasicAuthorization:
            return "invalidBasicAuthorization"
        case .invalidBearerAuthorization:
            return "invalidBearerAuthorization"
        case .noAuthorizationHeader:
            return "noAuthorizationHeader"
        case .notAuthenticated:
            return "notAuthenticated"
        case .invalidCredentials:
            return "invalidCredentials"
        case .unsupportedCredentials:
            return "unsupportedCredentials"
        case .unspecified(let error):
            return "unspecified (\(error))"
        }
    }
    
    public var suggestedFixes: [String] {
        return []
    }
    
    public var possibleCauses: [String] {
        return []
    }
}

