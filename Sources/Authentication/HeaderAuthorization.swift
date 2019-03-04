
public protocol HeaderAuthorization {
	var token: String { get }

	init(token: String)
}
