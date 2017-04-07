import Fluent

public protocol Authorizable: Entity {}

// MARK: Pivot

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
        guard let permission = try PermissionType.makeQuery().filter("key", permission.key).first() else {
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

extension PivotProtocol where Self.Right: Permission {
    public static func add(_ permissions: [Self.Right], to left: Self.Left) throws {
        for permission in permissions {
            try add(permission, to: left)
        }
    }
    
    public static func add(_ permission: Self.Right, to left: Self.Left) throws {
        guard let permission = try Self.Right
            .makeQuery()
            .filter("key", permission.key)
            .first()
        else {
            throw AuthorizationError.unknownPermission
        }
        
        try self.attach(left, permission)
    }
}


// MARK: Double Pivot

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
        guard let permission = try PermissionType.makeQuery().filter("key", permission.key).first() else {
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
