import Fluent

public protocol Authorizable: Entity {

}

extension Authorizable {
    public func isAuthorized<
        PermissionType: Permission,
        PivotType: PivotProtocol & Entity
    >(
        to permission: PermissionType,
        withPivot: PivotType.Type = PivotType.self
    ) throws -> Bool
        where
            PivotType.Left == Self,
            PivotType.Right == PermissionType
    {
        guard let permission = try PermissionType.query().filter("key", permission.key).first() else {
            throw AuthorizationError.unknownPermission
        }

        return try PivotType.related(self, permission)
    }


    public func assertAuthorization<
        PermissionType: Permission,
        PivotType: PivotProtocol & Entity
    >(
        to permission: PermissionType,
        withPivot pivot: PivotType.Type = PivotType.self
    ) throws
        where
            PivotType.Left == Self,
            PivotType.Right == PermissionType
    {
            guard try isAuthorized(to: permission, withPivot: PivotType.self) else {
                throw AuthorizationError.notAuthorized
            }
    }
}

extension Authorizable {
    public func isAuthorized<
        PermissionType: Permission,
        MiddleType: Entity,
        PivotType: PivotProtocol & Entity
    >(
        to permission: PermissionType,
        _ item: MiddleType,
        withPivot: PivotType.Type = PivotType.self
    ) throws -> Bool
        where
            PivotType.Left: PivotProtocol,
            PivotType.Left.Left == Self,
            PivotType.Left.Right == MiddleType,
            PivotType.Right == PermissionType
    {
        guard let permission = try PermissionType.query().filter("key", permission.key).first() else {
            throw AuthorizationError.unknownPermission
        }

        return try PivotType.related(left: self, middle: item, right: permission)
    }

    public func assertAuthorization<
        PermissionType: Permission,
        MiddleType: Entity,
        PivotType: PivotProtocol & Entity
    >(
        to permission: PermissionType,
        _ item: MiddleType,
        withPivot pivot: PivotType.Type = PivotType.self
    ) throws
        where
            PivotType.Left: PivotProtocol,
            PivotType.Left.Left == Self,
            PivotType.Left.Right == MiddleType,
            PivotType.Right == PermissionType
    {
        guard try isAuthorized(to: permission, item, withPivot: PivotType.self) else {
            throw AuthorizationError.notAuthorized
        }
    }
}
