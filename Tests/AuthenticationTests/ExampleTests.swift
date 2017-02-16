import XCTest
import Node

@testable import Authentication

class ExampleTests: XCTestCase {
    static let allTests = [
        ("testExample", testExample),
    ]

    func testExample() throws {
        do {
            let token = Token(string: "5")
            let user2 = try AuthUser.authenticate(token)
            XCTAssertEqual(user2.name, "6")
        } catch {
            XCTFail("\(error)")

        }
    }
}
