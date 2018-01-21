import Bits

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
    func verify(password: Bytes, matches hash: Bytes) throws -> Bool
}

extension PasswordVerifier {
    public func verify(password: BytesConvertible, matches hash: BytesConvertible) throws -> Bool {
        let password = try password.makeBytes()
        let hash = try hash.makeBytes()
        return try verify(password: password, matches: hash)
    }
}

// MARK: Entity conformance

import Fluent

extension PasswordAuthenticatable where Self: Entity {
    public static func authenticate(_ creds: Password) throws -> Self {
        let user: Self
        
        if let verifier = passwordVerifier {
            let match = try Self
                .makeQuery()
                .filter(usernameKey, creds.username)
                .first()
            let expectedPasswordHash = match?.hashedPassword ??
                "$2a$10$N5NH4Xt9uj18GCd7W9Rl2eHrw8k6lhGpds5w389ux.bwZFMK5WSiq"

            guard try verifier.verify(
                password: creds.password.makeBytes(),
                matches: expectedPasswordHash.makeBytes()
                ), let matchedUser = match else {
                    throw AuthenticationError.invalidCredentials
            }

            user = matchedUser
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
