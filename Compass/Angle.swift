//
//  Angle.swift
//  Compass
//
//  Created by Fabian Canas on 5/15/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public protocol Angle : Comparable {
    var value :Double { set get }
    static var Unit :Self { get }
    static var Zero :Self { get }
    init(_ value: Double)
    init<A :Angle>(angle: A)
}

public struct Degree : Angle {
    public var value :Double
    public static let Unit = Degree(360)
    public static let Zero = Degree(0)
    
    public init<T :Angle>(angle: T) {
        value = angle.value * (Degree.Unit.value / T.Unit.value)
    }
    public init(_ value: Double) {
        self.value = value
    }
}

public struct Radian : Angle {
    public var value :Double
    public static let Unit = Radian(2.0 * M_PI)
    public static let Zero = Radian(0)
    
    public init<T :Angle>(angle: T) {
        value = angle.value * (Radian.Unit.value / T.Unit.value)
    }
    public init(_ value: Double) {
        self.value = value
    }
}

public func % <A :Angle> (lhs: A, rhs: A) -> A {
    return A(lhs.value % rhs.value)
}

public func + <A :Angle> (lhs: A, rhs: A) -> A {
    return A(lhs.value + rhs.value)
}

public func - <A :Angle> (lhs: A, rhs: A) -> A {
    return A(lhs.value - rhs.value)
}

public func <= <A :Angle> (lhs: A, rhs: A) -> Bool {
    return lhs.value <= rhs.value
}

public func >= <A :Angle> (lhs: A, rhs: A) -> Bool {
    return lhs.value >= rhs.value
}

public func > <A :Angle> (lhs: A, rhs: A) -> Bool {
    return lhs.value > rhs.value
}

public func < <A :Angle> (lhs: A, rhs: A) -> Bool {
    return lhs.value < rhs.value
}

public func == <A :Angle> (lhs: A, rhs: A) -> Bool {
    return lhs.value == rhs.value
}

public func += <A :Angle> (inout lhs: A, rhs: A) {
    lhs.value = lhs.value + rhs.value
}

public func -= <A :Angle> (inout lhs: A, rhs: A) {
    lhs.value = lhs.value - rhs.value
}

public func abs <A: Angle> (angle: A) -> A {
    return A(abs(angle.value))
}

/// Given an angle, unwinds the angle around a circle to return an angle in the range [0, 2π) or [0, 360) depending on the angle type
public func unwindAngle <A :Angle> (angle: A) -> A {
    var unwoundAngle = angle % A.Unit
    if unwoundAngle < A.Zero {
        unwoundAngle += A.Unit
    }
    return unwoundAngle
}

