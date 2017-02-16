// MARK: Authenticatable

public protocol CustomAuthenticatable: Authenticatable {
    /// Returns the user matching the custom credential.
    static func authenticate(custom: Crendentials) throws -> Self
}
