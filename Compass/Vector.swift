//
//  Vector.swift
//  Compass
//
//  Created by Fabian Canas on 5/14/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public extension CGVector {
    // Returns the magnitude of the vector, i.e. how long is it?
    public var magnitude :CGFloat {
        get {
            return sqrt(self.dx * self.dx + self.dy * self.dy)
        }
    }
    
    /** Returns the result of scaling this vector by its magnitude, resulting in a vector that points in the same direction with a magnitude of 1.0
    */
    public var normalized: CGVector {
        get {
            return normalize(self)
        }
    }
    
    /// Returns the angle of the vector in radians
    public var angle: CGFloat {
        return atan2(dy, dx)
    }
}

/** Returns the result of scaling this vector by its magnitude, resulting in a vector that points in the same direction with a magnitude of 1.0
*/
public func normalize(v: CGVector) -> CGVector {
    let m = v.magnitude
    return CGVector(dx: v.dx/m, dy: v.dy/m)
}

public func - (lhs: CGVector , rhs: CGVector) -> CGVector {
    return CGVector(dx:lhs.dx-rhs.dx, dy:lhs.dy-rhs.dy)
}

public func + (lhs: CGVector , rhs: CGVector) -> CGVector {
    return CGVector(dx:lhs.dx+rhs.dx, dy:lhs.dy+rhs.dy)
}

public prefix func - (v: CGVector) -> CGVector {
    return CGVector(dx: -v.dx, dy: -v.dy)
}
