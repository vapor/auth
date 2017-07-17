extension AuthorizationHeader {
    public var bearer: Token? {
        guard let range = string.range(of: "Bearer ") else {
            return nil
        }
        
        let token = string.substring(from: range.upperBound)
        return Token(string: token)
    }
    
    public init(bearer: Token) {
        self.init(string: "Bearer \(bearer.string)")
    }
}
