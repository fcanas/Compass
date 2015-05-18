//
//  Angle.swift
//  Compass
//
//  Created by Fabian Canas on 5/15/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

/// Angle is a base protocol for typed angles to prevent unintentianal mixing of Angles and Degrees
public protocol Angle : Comparable, FloatLiteralConvertible, IntegerLiteralConvertible, SignedNumberType, AbsoluteValuable {
    var value :Double { set get }
    static var Unit :Self { get }
    init(_ value: Double)
    init<A :Angle>(angle: A)
}

/// Degree is a measurement of an angle where 1/360 represents a full rotation.
public struct Degree : Angle {
    public var value :Double
    public static let Unit = Degree(360)
    
    public init<T :Angle>(angle: T) {
        value = angle.value * (Degree.Unit.value / T.Unit.value)
    }
    public init(_ value: Double) {
        self.value = value
    }
    
    public static func abs(x: Degree) -> Degree {
        return abs_a(x)
    }
}

extension Degree: FloatLiteralConvertible {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

extension Degree: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Double(value))
    }
}

/// Radian is a measurement of an angle where 2π represents a full rotation.
public struct Radian : Angle {
    public var value :Double
    public static let Unit = Radian(2.0 * M_PI)
    
    public init<T :Angle>(angle: T) {
        value = angle.value * (Radian.Unit.value / T.Unit.value)
    }
    public init(_ value: Double) {
        self.value = value
    }
    
    public static func abs(x: Radian) -> Radian {
        return abs_a(x)
    }
}

extension Radian: FloatLiteralConvertible {
    public init(floatLiteral value: Double) {
        self.init(value)
    }
}

extension Radian: IntegerLiteralConvertible {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(Double(value))
    }
}

private func abs_a <A: Angle> (angle: A) -> A {
    return A(abs(angle.value))
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

public prefix func - <A: Angle> (angle: A) -> A {
    return A(-angle.value)
}

public func numericCast<T: Angle, U: Angle>(x: T) -> U {
    return U(angle: x)
}

/// Given an angle, unwinds the angle around a circle to return an angle in the range [0, 2π) or [0, 360) depending on the angle type
public func unwindAngle <A :Angle> (angle: A) -> A {
    var unwoundAngle = angle % A.Unit
    if unwoundAngle < A(0.0) {
        unwoundAngle += A.Unit
    }
    return unwoundAngle
}

