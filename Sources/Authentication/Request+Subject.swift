import Turnstile

extension Subject {
    var sessionIdentifier: String? {
        return authDetails?.sessionID
    }
}
