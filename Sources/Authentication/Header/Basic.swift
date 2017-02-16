import Core

extension Authorization {
    public var basic: Password? {
        guard let range = header.range(of: "Basic ") else {
            return nil
        }

        let token = header.substring(from: range.upperBound)


        let decodedToken = token.makeBytes().base64Decoded.string
        guard let separatorRange = decodedToken.range(of: ":") else {
            return nil
        }

        let apiKeyID = decodedToken.substring(to: separatorRange.lowerBound)
        let apiKeySecret = decodedToken.substring(from: separatorRange.upperBound)

        return Password(username: apiKeyID, password: apiKeySecret)
    }
}
