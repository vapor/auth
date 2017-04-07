public protocol PasswordAuthenticatable: Authenticatable {
    // MARK:  Username / Password
    /// Return the user matching the supplied
    /// username and password
    static func authenticate(_: Password) throws -> Self
    
    /// The entity's hashed password used for
    /// validating against Password credentials
    /// with a PasswordVerifier
    var hashedPassword: String? { get }
    
    /// The key under which the user's username,
    /// email, or other identifing value is stored.
    static var usernameKey: String { get }
    
    /// The key under which the user's password
    /// is stored.
    static var passwordKey: String { get }
    
    /// Optional password verifier to use when
    /// comparing plaintext passwords from the
    /// Authorization header to hashed passwords
    /// in the database.
    static var passwordVerifier: PasswordVerifier? { get }
}

extension PasswordAuthenticatable {
    public static var usernameKey: String {
        return "email"
    }
    
    public static var passwordKey: String {
        return "password"
    }
    
    public var hashedPassword: String? {
        return nil
    }
    
    public static var passwordVerifier: PasswordVerifier? {
        return nil
    }
}


public protocol PasswordVerifier {
    func verify(password: String, matchesHash: String) throws -> Bool
}

// MARK: Entity conformance

import Fluent

extension PasswordAuthenticatable where Self: Entity {
    public static func authenticate(_ creds: Password) throws -> Self {
        let user: Self
        
        if let verifier = passwordVerifier {
            guard let match = try Self
                .makeQuery()
                .filter(usernameKey, creds.username)
                .first()
                else {
                    throw AuthenticationError.invalidCredentials
            }
            
            guard let hash = match.hashedPassword else {
                throw AuthenticationError.invalidCredentials
            }
            
            guard try verifier.verify(
                password: creds.password,
                matchesHash: hash
                ) else {
                    throw AuthenticationError.invalidCredentials
            }
            
            user = match
        } else {
            guard let match = try Self
                .makeQuery()
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
