import Bits
import Crypto
import HTTP

extension HTTPHeaders {
    /// Access or set the `Authorization: Bearer: ...` header.
    public var bearerAuthorization: BearerAuthorization? {
        get {
            guard let string = self[.authorization].first else {
                return nil
            }

            guard let range = string.range(of: "Bearer ") else {
                return nil
            }

            let token = string[range.upperBound...]
            return .init(token: String(token))
        }
        set {
            if let bearer = newValue {
                replaceOrAdd(name: .authorization, value: "Bearer \(bearer.token)")
            } else {
                remove(name: .authorization)
            }
        }
    }
}
