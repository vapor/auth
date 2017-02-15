extension Authorization {
    public var bearer: Credentials? {
        guard let range = header.range(of: "Bearer ") else {
            return nil
        }

        let token = header.substring(from: range.upperBound)
        return Credentials(token: token)
    }
}
