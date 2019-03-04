
/// Authenticatable by a value found
/// in one of the HTTP headers.
public protocol HeaderAuthenticatable: Authenticatable {
	/// The type of authorization being used.
	/// Most commonly this is BearerAuthorization
	/// but ValueAuthorization can be used if you are
	/// authenticating with a value not found in the
	/// Authorization: Bearer header.
	associatedtype AuthorizationType: HeaderAuthorization

	/// Key path to the token
	typealias TokenKey = WritableKeyPath<Self, String>

	/// The key under which the model's unique token is stored.
	static var tokenKey: TokenKey { get }

	/// Attempt to retrieve an authorization value from
	/// the given headers.
	///	- parameter headers:
	static func authorization(from headers: HTTPHeaders) -> AuthorizationType?

	/// Authenticates using the supplied credentials and connection.
	static func authenticate(using auth: AuthorizationType, on connection: DatabaseConnectable) -> Future<Self?>
}

extension HeaderAuthenticatable where Self: Model {
	/// See `HeaderAuthenticatable`.
	public static func authenticate(using auth: AuthorizationType, on conn: DatabaseConnectable) -> Future<Self?> {
		return Self.query(on: conn).filter(tokenKey == auth.token).first()
	}
}

extension HeaderAuthenticatable {
	/// Accesses the model's token
	public var authToken: String {
		get { return self[keyPath: Self.tokenKey] }
		set { self[keyPath: Self.tokenKey] = newValue }
	}
}
