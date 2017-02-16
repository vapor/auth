// MARK: Data structure

public struct Password: Crendentials {
    public let username: String
    public let password: String
    public let verifier: PasswordVerifier?

    public init(username: String, password: String, verifier: PasswordVerifier? = nil) {
        self.username = username
        self.password = password
        self.verifier = verifier
    }
}

// MARK: Authenticatable

public protocol PasswordAuthenticatable: Authenticatable {
    // MARK:  Username / Password
    /// Return the user matching the supplied
    /// username and password
    static func authenticate(_: Password) throws -> Self

    /// The entity's raw or hashed password
    var password: String? { get }

    /// The key under which the user's username,
    /// email, or other identifing value is stored.
    static var usernameKey: String { get }

    /// The key under which the user's password
    /// is stored.
    static var passwordKey: String { get }
}

public protocol PasswordVerifier {
    func verify(password: String, matchesPassword: String) throws -> Bool
}

// MARK: Entity conformance

import Fluent

extension PasswordAuthenticatable where Self: Entity {
    public static func authenticate(_ creds: Password) throws -> Self {
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
