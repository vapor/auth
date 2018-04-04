import Async
@_exported import BCrypt
import Service

/// Adds authentication services to a container
public final class AuthenticationProvider: Provider {
    /// See Provider.repositoryName
    public static var repositoryName: String = "auth"

    /// Create a new authentication provider
    public init() { }

    /// See Provider.register
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
