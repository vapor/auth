
/// Protects a route group, requiring a token authenticatable
/// instance to pass through.
///
/// use `req.requireAuthenticated(A.self)` to fetch the instance.
public final class BearerAuthenticationMiddleware<A>: HeaderAuthenticationMiddleware<A> where A: BearerAuthenticatable {}

extension BearerAuthenticatable {
	/// Creates a bearer auth middleware for this model.
	/// See `BearerAuthenticationMiddleware`.
	public static func bearerAuthMiddleware() -> BearerAuthenticationMiddleware<Self> {
		return BearerAuthenticationMiddleware()
	}
}
