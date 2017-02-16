public enum AuthorizationError: Error {
    case unknownPermission
    case notAuthorized
    case unspecified(Error)
}

extension AuthorizationError: CustomStringConvertible {
    public var description: String {
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
}
