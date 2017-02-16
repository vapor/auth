import Authentication
import Node
import Fluent

final class AuthUser: Entity {
    var id: Node?
    var name: String
    var exists: Bool = false
    
    init(name: String) {
        self.name = name
    }
    
    init(node: Node, in context: Context) throws {
        self.id = nil
        self.name = try node.extract("name")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name
        ])
    }
    
    static func prepare(_ database: Database) throws {
    }
    
    static func revert(_ database: Database) throws {
        
    }
}

extension AuthUser: IdentifierAuthenticatable {
    static func authenticate(_ id: Identifier) throws -> Self {
        return self.init(name: "5")
    }
}

extension AuthUser: TokenAuthenticatable {
    typealias TokenType = AuthUser

    static func authenticate(_ id: Token) throws -> Self {
        return self.init(name: "6")
    }
}

extension AuthUser: TokenProtocol {
    static var tokenKey: String {
        return ""
    }
}
