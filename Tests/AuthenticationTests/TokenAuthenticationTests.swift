//
//  TokenAuthenticationTests.swift
//  AuthenticationTests
//
//  Created by Mathew Polzin on 3/3/19.
//

import XCTest
import Authentication
import FluentSQLite

class TokenAuthenticationTests: XCTestCase {

	func test_HeaderAuthUser_resultsInHeaderAuthMiddleware() {
		let middleware = HeaderTokenAuthUser.tokenAuthMiddleware()

		XCTAssert(type(of: middleware.headerAuthMiddleware).self == HeaderAuthenticationMiddleware<HeaderAuthToken>.self)
	}

	func test_BearerAuthUser_resultsInBearerAuthMiddleware() {
		let middleware = BearerTokenAuthUser.tokenAuthMiddleware()

		XCTAssert(type(of: middleware.headerAuthMiddleware).self == BearerAuthenticationMiddleware<BearerAuthToken>.self)
	}

	func test_HeaderAuthExtractsSessionToken() {
		var headers = HTTPHeaders()
		let testToken = "abcdef1234"

		headers.add(name: .sessionToken, value: testToken)

		XCTAssertEqual(HeaderAuthToken.authorization(from: headers)?.token, testToken)

		// sanity check test
		XCTAssertNil(BearerAuthToken.authorization(from: headers)?.token)
	}

	func test_BearerAuthExtractsSessionToken() {
		var headers = HTTPHeaders()
		let testToken = "abcdef1234"

		headers.bearerAuthorization = BearerAuthorization(token: testToken)

		XCTAssertEqual(BearerAuthToken.authorization(from: headers)?.token, testToken)

		// sanity check test
		XCTAssertNil(HeaderAuthToken.authorization(from: headers)?.token)
	}

}

private extension HTTPHeaderName {
	static let sessionToken: HTTPHeaderName = HTTPHeaderName("Session-Token")
}

// MARK: - Header Auth Types
private struct HeaderTokenAuthUser: Model, TokenAuthenticatable {
	typealias TokenType = HeaderAuthToken
	typealias Database = SQLiteDatabase
	typealias ID = UUID

	static let idKey: WritableKeyPath<HeaderTokenAuthUser, UUID?> = \.id

	var id: UUID?
	var name: String

	var tokens: Children<HeaderTokenAuthUser, HeaderAuthToken> {
		return children(\.userId)
	}
}

private struct HeaderAuthToken: Model, Token {
	static func authorization(from headers: HTTPHeaders) -> ValueAuthorization? {
		return headers[.sessionToken].first.map(ValueAuthorization.init(token:))
	}

	typealias UserType = HeaderTokenAuthUser
	typealias AuthorizationType = ValueAuthorization
	typealias Database = SQLiteDatabase
	typealias ID = UUID

	static let idKey: WritableKeyPath<HeaderAuthToken, UUID?> = \.id
	static let tokenKey: WritableKeyPath<HeaderAuthToken, String> = \.token
	static let userIDKey: WritableKeyPath<HeaderAuthToken, HeaderTokenAuthUser.ID> = \.userId

	var id: UUID?

	var token: String
	var userId: UUID

	var user: Parent<HeaderAuthToken, HeaderTokenAuthUser> {
		return parent(\.userId)
	}
}

// MARK: - Bearer Auth Types
private struct BearerTokenAuthUser: Model, TokenAuthenticatable {
	typealias TokenType = BearerAuthToken
	typealias Database = SQLiteDatabase
	typealias ID = UUID

	static let idKey: WritableKeyPath<BearerTokenAuthUser, UUID?> = \.id

	var id: UUID?
	var name: String

	var tokens: Children<BearerTokenAuthUser, BearerAuthToken> {
		return children(\.userId)
	}
}

private struct BearerAuthToken: Model, BearerAuthenticatable, Token {
	typealias UserType = BearerTokenAuthUser
	typealias Database = SQLiteDatabase
	typealias ID = UUID

	static let idKey: WritableKeyPath<BearerAuthToken, UUID?> = \.id
	static let tokenKey: WritableKeyPath<BearerAuthToken, String> = \.token
	static let userIDKey: WritableKeyPath<BearerAuthToken, BearerTokenAuthUser.ID> = \.userId

	var id: UUID?

	var token: String
	var userId: UUID

	var user: Parent<BearerAuthToken, BearerTokenAuthUser> {
		return parent(\.userId)
	}
}
