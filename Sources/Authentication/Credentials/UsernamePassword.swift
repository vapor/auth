public struct UsernamePassword {
    public let username: String
    public let password: String
    public let verifier: PasswordVerifier?

    public init(username: String, password: String, verifier: PasswordVerifier? = nil) {
        self.username = username
        self.password = password
        self.verifier = verifier
    }
}


public protocol PasswordVerifier {
    func verify(password: String, matchesPassword: String) throws -> Bool
}

extension User {
    public static func authenticate(_ creds: UsernamePassword) throws -> Self {
        let user: Self

        if let verifier = creds.verifier {
            guard let match = try Self
                .query()
                .filter(usernameKey, creds.username)
                .first()
                else {
                    throw AuthenticationError.invalidCredentials
            }

            guard let matchPassword = match.password else {
                throw AuthenticationError.invalidCredentials
            }

            guard try verifier.verify(
                password: creds.password,
                matchesPassword: matchPassword
                ) else {
                    throw AuthenticationError.invalidCredentials
            }

            user = match
        } else {
            guard let match = try Self
                .query()
                .filter(usernameKey, creds.username)
                .filter(passwordKey, creds.password)
                .first()
                else {
                    throw AuthenticationError.invalidCredentials
            }

            user = match
        }
        
        return user
    }
}




import Fluent

public protocol TokenCredentialEntity: Entity {
    func authenticationUser() throws -> User
    static var tokenKey: String { get }
}
