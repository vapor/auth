public protocol Authenticatable {
    // MARK: General
    static func authenticate(_: Credentials) throws -> Self

    // MARK: Identifier
    static func authenticate(_: Identifier) throws -> Self

    // MARK:  Username / Password
    /// Return the user matching the supplied
    /// username and password
    static func authenticate(_: UsernamePassword) throws -> Self

    /// The entity's raw or hashed password
    var password: String? { get }

    /// The key under which the user's username,
    /// email, or other identifing value is stored.
    static var usernameKey: String { get }

    /// The key under which the user's password
    /// is stored.
    static var passwordKey: String { get }


    // MARK: Token
    /// Returns the user matching the supplied token.
    static func authenticate(_: Token) throws -> Self

    /// The token entity that contains a foreign key
    /// pointer to the user table
    static var tokenType: TokenCredentialEntity.Type? { get }

    // MARK: Custom
    /// Returns the user matching the custom credential.
    static func authenticate(custom: Any) throws -> Self
}

extension User {
    /// See User.password in Protocol
    public var password: String? {
        return nil
    }

    /// See User.usernameKey in Protocol
    public static var usernameKey: String {
        return "username"
    }

    /// See User.passwordKey in Protocol
    public static var passwordKey: String {
        return "password"
    }

    /// See User.tokenType in Protocol
    public static var tokenType: TokenCredentialEntity.Type? {
        return nil
    }
}
