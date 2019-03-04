
public protocol HeaderValueAuthorization {
	var token: String { get }

	init(token: String)
}
