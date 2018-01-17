import Vapor

public struct RedirectMiddleware<A>: Middleware where A: Authenticatable {

    let path: String

    public init(A authenticableType: A.Type = A.self, path: String) {
        self.path = path
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        if try request.isAuthenticated(A.self) {
            return try next.respond(to: request)
        }
        return Future(request.redirect(to: path))
    }
}
