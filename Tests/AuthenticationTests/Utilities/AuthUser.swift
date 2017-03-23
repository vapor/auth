import Authentication
import Node
import Fluent

final class AuthUser: Entity {
    var name: String
    let storage = Storage()
    
    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        name = try row.get("name")
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        return row
    }
}

extension AuthUser: TokenAuthenticatable {
    typealias TokenType = AuthUser

    static func authenticate(_ id: Token) throws -> Self {
        return self.init(name: "6")
    }
}
