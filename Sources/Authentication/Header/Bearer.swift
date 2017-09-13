extension AuthorizationHeader {
    public var bearer: Token? {
        guard let range = string.range(of: "Bearer ") else {
            return nil
        }

        #if swift(>=4)
            let token = string[range.upperBound...]
            return Token(string: String(token))
        #else
            let token = string.substring(from: range.upperBound)
            return Token(string: token)
        #endif
    }

    public init(bearer: Token) {
        self.init(string: "Bearer \(bearer.string)")
    }
}
