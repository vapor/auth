import Foundation

/// Capable of converting to/from a String.
public protocol StringConvertible {
    /// Statically converts a string to a `Self`.
    static func convertFromString(_ string: String) throws -> Self

    /// Converts `self` to a String.
    func convertToString() throws -> String
}

extension String: StringConvertible {
    /// See `StringConvertible.convertFromString(_:)`
    public static func convertFromString(_ string: String) throws -> String {
        return string
    }

    /// See `StringConvertible.convertToString()`
    public func convertToString() throws -> String {
        return self
    }
}

extension FixedWidthInteger {
    /// See `StringConvertible.convertFromString(_:)`
    public static func convertFromString(_ string: String) throws -> Self {
        guard let fwi = Self(string) else {
            throw AuthenticationError(identifier: "fixedWidthInteger", reason: "Could not convert string \(string) to \(Self.self)", source: .capture())
        }
        return fwi
    }

    /// See `StringConvertible.convertToString()`
    public func convertToString() throws -> String {
        return description
    }
}

extension Int: StringConvertible { }
extension Int8: StringConvertible { }
extension Int16: StringConvertible { }
extension Int32: StringConvertible { }
extension Int64: StringConvertible { }
extension UInt: StringConvertible { }
extension UInt8: StringConvertible { }
extension UInt16: StringConvertible { }
extension UInt32: StringConvertible { }
extension UInt64: StringConvertible { }

extension UUID: StringConvertible {
    /// See `StringConvertible.convertFromString(_:)`
    public static func convertFromString(_ string: String) throws -> UUID {
        guard let uuid = UUID(uuidString: string) else {
            throw AuthenticationError(identifier: "uuid", reason: "Could not convert string \(string) to UUID", source: .capture())
        }
        return uuid
    }

    /// See `StringConvertible.convertToString()`
    public func convertToString() throws -> String {
        return uuidString
    }
}
