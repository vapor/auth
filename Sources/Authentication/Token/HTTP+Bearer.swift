import Bits
import Crypto
import HTTP

extension HTTPHeaders {
    /// Access or set the `Authorization: Basic: ...` header.
    public var bearerAuthorization: BearerToken? {
        get {
            guard let string = self[.authorization] else {
                return nil
            }

            guard let range = string.range(of: "Bearer ") else {
                return nil
            }

            let token = string[range.upperBound...]
            return .init(string: String(token))
        }
        set {
            if let token = newValue {
                self[.authorization] = "Bearer \(token.string)"
            } else {
                self[.authorization] = nil
            }
        }
    }
}
