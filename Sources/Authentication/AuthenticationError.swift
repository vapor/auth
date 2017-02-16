public enum AuthenticationError: Swift.Error {
    case invalidAccountType
    case invalidBasicAuthorization
    case invalidBearerAuthorization
    case noAuthorizationHeader
    case notAuthenticated
    case invalidIdentifier
    case invalidCredentials
    case unsupportedCredentials
}
