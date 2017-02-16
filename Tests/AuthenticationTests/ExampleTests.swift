import XCTest
import Node

@testable import Authentication

class ExampleTests: XCTestCase {
    static let allTests = [
        ("testExample", testExample),
    ]

    func testExample() throws {
        do {
            let id = Identifier(id: Node.string("5"))
            let token = Token(string: "5")

            let user1 = try AuthUser.authenticate(id)
            XCTAssertEqual(user1.name, "5")

            let user2 = try AuthUser.authenticate(token)
            XCTAssertEqual(user2.name, "6")
        } catch {
            XCTFail("\(error)")

        }
    }
}
