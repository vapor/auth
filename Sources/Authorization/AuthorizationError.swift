import Debugging

public enum AuthorizationError: Error {
    case unknownPermission
    case notAuthorized
    case unspecified(Error)
}

extension AuthorizationError: Debuggable {
    public var reason: String {
        let reason: String

        switch self {
        case .unknownPermission:
            reason = "Permission not recognized."
        case .notAuthorized:
            reason = "Not authorized"
        case .unspecified(let error):
            reason = "\(error)"
        }

        return "Authorization error: \(reason)"
    }
    
    public var identifier: String {
        switch self {
        case .unknownPermission:
            return "unknownPermission"
        case .notAuthorized:
            return "notAuthorized"
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
