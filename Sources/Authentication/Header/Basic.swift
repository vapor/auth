import Core

extension AuthorizationHeader {
    public var basic: Password? {
        guard let range = string.range(of: "Basic ") else {
            return nil
        }

        let token = string.substring(from: range.upperBound)

        let decodedToken = token.makeBytes().base64Decoded.makeString()
        guard let separatorRange = decodedToken.range(of: ":") else {
            return nil
        }

        let username = decodedToken.substring(to: separatorRange.lowerBound)
        let password = decodedToken.substring(from: separatorRange.upperBound)

        return Password(username: username, password: password)
    }
}
