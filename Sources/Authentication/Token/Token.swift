/// A basic username and password.
public struct BearerToken {
    /// The plaintext token
    public let string: String

    /// Create a new Password
    public init(string: String) {
        self.string = string
    }
}
