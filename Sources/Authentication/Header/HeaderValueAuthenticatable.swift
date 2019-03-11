
/// Authenticatable by a value found
/// in one of the HTTP headers.
public protocol HeaderValueAuthenticatable: Authenticatable {
    /// Key path to the token
    typealias TokenKey = WritableKeyPath<Self, String>

    /// The key under which the model's unique token is stored.
    static var tokenKey: TokenKey { get }

    /// Attempt to retrieve an authorization value from
    /// the given headers.
    ///	- parameter headers:
    static func authToken(from headers: HTTPHeaders) -> String?

    /// Authenticates using the supplied credentials and connection.
    static func authenticate(using authToken: String, on connection: DatabaseConnectable) -> Future<Self?>
}

extension HeaderValueAuthenticatable where Self: Model {
    /// See `HeaderAuthenticatable`.
    public static func authenticate(using authToken: String, on conn: DatabaseConnectable) -> Future<Self?> {
        return Self.query(on: conn).filter(tokenKey == authToken).first()
    }
}

extension HeaderValueAuthenticatable {
    /// Accesses the model's token
    public var authToken: String {
        get { return self[keyPath: Self.tokenKey] }
        set { self[keyPath: Self.tokenKey] = newValue }
    }
}
