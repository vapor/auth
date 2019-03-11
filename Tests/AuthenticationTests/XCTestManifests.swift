import XCTest

extension AuthenticationTests {
    static let __allTests = [
        ("testApplication", testApplication),
        ("testPassword", testPassword),
        ("testSessionPersist", testSessionPersist),
    ]
}

extension TokenAuthenticationTests {
    static let __allTests = [
        ("test_BearerAuthExtractsSessionToken", test_BearerAuthExtractsSessionToken),
        ("test_BearerAuthUser_resultsInBearerAuthMiddleware", test_BearerAuthUser_resultsInBearerAuthMiddleware),
        ("test_HeaderAuthExtractsSessionToken", test_HeaderAuthExtractsSessionToken),
        ("test_HeaderAuthUser_resultsInHeaderAuthMiddleware", test_HeaderAuthUser_resultsInHeaderAuthMiddleware),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AuthenticationTests.__allTests),
        testCase(TokenAuthenticationTests.__allTests),
    ]
}
#endif
