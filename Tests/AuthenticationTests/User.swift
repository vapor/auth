import Authentication
import Async
import FluentSQLite
import Foundation

extension DatabaseIdentifier {
    static var test: DatabaseIdentifier<SQLiteDatabase> {
        return .init("test")
    }
}

final class User: Model, Migration, BasicAuthenticatable, SessionAuthenticatable {
    typealias Database = SQLiteDatabase
    typealias ID = UUID
    
    static let idKey: IDKey = \User.id
    static let usernameKey: UsernameKey = \User.email
    static let passwordKey: PasswordKey = \User.password

    var id: UUID?
    var name: String
    var email: String
    var password: String

    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
