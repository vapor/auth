import Debugging

/// Errors that can be thrown while working with Authentication.
public struct AuthenticationError: Debuggable {
    /// See Debuggable.readableName
    public static let readableName = "Authentication Error"

    /// See Debuggable.reason
    public let identifier: String

    /// See Debuggable.reason
    public var reason: String

    /// See Debuggable.sourceLocation
    public var sourceLocation: SourceLocation?

    /// See stackTrace
    public var stackTrace: [String]

    /// Create a new authentication error.
    init(
        identifier: String,
        reason: String,
        source: SourceLocation
    ) {
        self.identifier = identifier
        self.reason = reason
        self.sourceLocation = source
        self.stackTrace = AuthenticationError.makeStackTrace()
    }
}

extension AuthenticationError: AbortError {
    /// See AbortError.status
    public var status: HTTPStatus {
        return .unauthorized
    }
}
