/// Adds authentication services to a container
public final class AuthenticationProvider: Provider {
    /// Create a new `AuthenticationProvider`.
    public init() { }

    /// See `Provider`.
    public func register(_ services: inout Services) throws {
        services.register(PasswordVerifier.self) { container in
            return BCryptDigest()
        }
        services.register(PasswordVerifier.self) { container in
            return PlaintextVerifier()
        }
        services.register { container in
            return AuthenticationCache()
        }
    }

    /// See Provider.boot
    public func didBoot(_ worker: Container) throws -> Future<Void> {
        return .done(on: worker)
    }
}

/// A struct password verifier around bcrypt
extension BCryptDigest: PasswordVerifier { }
