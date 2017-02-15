extension User {
    public static func authenticate(_ credentials: Credentials) throws -> Self {
        let user: Self

        switch credentials {
        case .identifier(let id):
            user = try authenticate(id)
        case .password(let usernamePassword):
            user = try authenticate(usernamePassword)
        case .token(let token):
            user = try authenticate(token)
        case .custom:
            throw AuthenticationError.unsupportedCredentials
        }
        
        return user
    }
}

extension User {
    public static func authenticate(custom: Any) throws -> Self {
        throw AuthenticationError.unsupportedCredentials
    }
}
