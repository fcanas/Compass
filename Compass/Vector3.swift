//
//  Vector3.swift
//  Compass
//
//  Created by Fabian Canas on 6/3/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public struct Vector3 :Printable {
    public var dx :Double
    public var dy :Double
    public var dz :Double
    
    public init(dx: Double, dy: Double, dz: Double) {
        self.dx = dx
        self.dy = dy
        self.dz = dz
    }
    
    public var description :String {
        get {
            return "(\(dx), \(dy), \(dz))"
        }
    }
}

public func magnitude(v: Vector3) -> Double {
    return sqrt(v.dx * v.dx + v.dy * v.dy + v.dz * v.dz)
}

public func normalize(v: Vector3) -> Vector3 {
    let m = magnitude(v)
    return Vector3(dx: v.dx/m, dy: v.dy/m, dz: v.dx/m)
}

public func dot(v1: Vector3, v2: Vector3) -> Double {
    return v1.dx * v2.dx + v1.dy * v2.dy + v1.dz * v2.dz
}

public func cross(v1: Vector3, v2: Vector3) -> Vector3 {
    return Vector3(
        dx: v1.dy*v2.dz - v1.dz*v2.dy,
        dy: v1.dz*v2.dx - v1.dx*v2.dz,
        dz: v1.dx*v2.dy - v1.dy*v2.dx
    )
}

public func - (lhs: Vector3, rhs: Vector3) -> Vector3 {
    return Vector3(dx: lhs.dx-rhs.dx, dy: lhs.dy-rhs.dy, dz: lhs.dz-rhs.dz)
}

public func + (lhs: Vector3, rhs: Vector3) -> Vector3 {
    return Vector3(dx: lhs.dx+rhs.dx, dy: lhs.dy+rhs.dy, dz: lhs.dz+rhs.dz)
}
