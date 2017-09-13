extension AuthorizationHeader {
    public var basic: Password? {
        guard let range = string.range(of: "Basic ") else {
            return nil
        }

        #if swift(>=4)
            let token = string[range.upperBound...]

            let decodedToken = String(token).makeBytes().base64Decoded.makeString()
            guard let separatorRange = decodedToken.range(of: ":") else {
                return nil
            }

            let username = decodedToken[...separatorRange.lowerBound]
            let password = decodedToken[separatorRange.upperBound...]

            return Password(username: String(username), password: String(password))
        #else
            let token = string.substring(from: range.upperBound)

            let decodedToken = token.makeBytes().base64Decoded.makeString()
            guard let separatorRange = decodedToken.range(of: ":") else {
                return nil
            }

            let username = decodedToken.substring(to: separatorRange.lowerBound)
            let password = decodedToken.substring(from: separatorRange.upperBound)

            return Password(username: username, password: password)
        #endif
    }

    public init(basic: Password) {
        let credentials = "\(basic.username):\(basic.password)"
        let encoded = credentials.makeBytes().base64Encoded.makeString()
        self.init(string: "Basic \(encoded)")
    }
}
