public struct Token {
    public let token: String

    public init(token: String) {
        self.token = token
    }
}

extension User {
    public static func authenticate(_ token: Token) throws -> Self {
        //        guard let tokenType = tokenType else {
        //            throw AuthError.unsupportedCredentials
        //        }

        //            guard let user = try Self.query()
        //                .union(tokenType)
        //                .filter(tokenType, tokenType.tokenKey, token)
        //                .first()
        //            else {
        //                throw AuthError.unsupportedCredentials
        //            }

        throw AuthenticationError.unsupportedCredentials
    }
}
