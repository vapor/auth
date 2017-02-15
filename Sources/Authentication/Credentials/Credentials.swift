import Node

public enum Credentials {
    case identifier(Identifier)
    case password(UsernamePassword)
    case token(Token)
    case custom(Any)

    public init(token: String) {
        let token = Token(token: token)
        self = .token(token)
    }

    public init(identifier: Node) {
        let identifier = Identifier(id: identifier)
        self = .identifier(identifier)
    }


    public init(username: String, password: String, verifier: PasswordVerifier? = nil) {
        let creds = UsernamePassword(
            username: username,
            password: password,
            verifier: verifier
        )

        self = .password(creds)
    }


    public init(custom: Any) {
        self = .custom(custom)
    }
}
