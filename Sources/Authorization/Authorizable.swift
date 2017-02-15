import Fluent

public protocol Authorizable: Entity {

}

public protocol Pivot {
    associatedtype Left = Entity
    associatedtype Right = Entity

    static func contains(left: Left, right: Right) throws -> Bool
    static func attach(left: Left, right: Right) throws
    static func detach(left: Left, right: Right) throws
}

extension Pivot where Self: Entity {
    // implement some of the contains, attach, detach methods
}

extension Authorizable {
    public func isAuthorized<
        PermissionType: Permission,
        PivotType: Pivot
    >(
        to permission: PermissionType,
        withPivot: PivotType.Type = PivotType.self
    ) throws -> Bool
        where
            PivotType.Left == Self,
            PivotType.Right == PermissionType
    {
        guard let permission = try PermissionType.query().filter("key", permission.key).first() else {
            throw AuthorizationError.unknownPermissionKey
        }

        return try PivotType.contains(left: self, right: permission)
    }


    public func assertAuthorization<
        PermissionType: Permission,
        PivotType: Pivot
    >(
        to permission: PermissionType,
        withPivot pivot: PivotType.Type = PivotType.self
    ) throws
        where
            PivotType.Left == Self,
            PivotType.Right == PermissionType
    {
            guard try isAuthorized(to: permission, withPivot: pivot) else {
                throw AuthorizationError.notAuthorized
            }
    }
}

// MARK: Triple

public protocol TriplePivot {
    associatedtype Left = Entity
    associatedtype Middle = Entity
    associatedtype Right = Entity

    static func contains(left: Left, middle: Middle, right: Right) throws -> Bool
    static func attach(left: Left, middle: Middle, right: Right) throws
    static func detach(left: Left, middle: Middle, right: Right) throws
}

extension Authorizable {

    public func isAuthorized<
        PermissionType: Permission,
        MiddleEntityType: Entity,
        PivotType: TriplePivot
    >(
        to permission: PermissionType,
        _ item: MiddleEntityType,
        withPivot: PivotType.Type = PivotType.self
    ) throws -> Bool
        where
            PivotType.Left == Self,
            PivotType.Middle == MiddleEntityType,
            PivotType.Right == PermissionType
    {
        guard let permission = try PermissionType.query().filter("key", permission.key).first() else {
            throw AuthorizationError.unknownPermissionKey
        }

        return try PivotType.contains(left: self, middle: item, right: permission)
    }

    public func assertAuthorization<
        PermissionType: Permission,
        MiddleEntityType: Entity,
        PivotType: TriplePivot
    >(
        to permission: PermissionType,
        _ item: MiddleEntityType,
        withPivot pivot: PivotType.Type = PivotType.self
    ) throws
        where
            PivotType.Left == Self,
            PivotType.Middle == MiddleEntityType,
            PivotType.Right == PermissionType
    {
        guard try isAuthorized(to: permission, item, withPivot: pivot) else {
            throw AuthorizationError.notAuthorized
        }
    }
}

public enum AuthorizationError: Error {
    case authorizableIdentifierRequired
    case unknownPermissionKey
    case permissionIdentifierRequired
    case notAuthorized
    case unspecified(Error)
}
