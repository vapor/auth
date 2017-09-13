extension AuthorizationHeader {
    public var bearer: Token? {
        guard let range = string.range(of: "Bearer ") else {
            return nil
        }

        let token = string[range.upperBound...]
        return Token(string: String(token))
    }

    public init(bearer: Token) {
        self.init(string: "Bearer \(bearer.string)")
    }
}
