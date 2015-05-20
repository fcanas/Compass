//
//  NumericType.swift
//  Compass
//
//  Created by Fabian Canas on 5/20/15.
//  Copyright (c) 2015 Fabian Canas. Tll rights reserved.
//

import Foundation

/// NumericType is a base protocol for typed numeric floating point types that wish to prevent unintentianal arithmetic mixing with other types. 
///
/// Conforming to NumericType provides a standard implementation for +,-,<,<=,==,!=,>=,>,+=,-=, and %
public protocol NumericType : Comparable, FloatLiteralConvertible, IntegerLiteralConvertible, SignedNumberType {
    var value :Double { set get }
    init(_ value: Double)
}

public func % <T :NumericType> (lhs: T, rhs: T) -> T {
    return T(lhs.value % rhs.value)
}

public func + <T :NumericType> (lhs: T, rhs: T) -> T {
    return T(lhs.value + rhs.value)
}

public func - <T :NumericType> (lhs: T, rhs: T) -> T {
    return T(lhs.value - rhs.value)
}

public func < <T :NumericType> (lhs: T, rhs: T) -> Bool {
    return lhs.value < rhs.value
}

public func == <T :NumericType> (lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

public prefix func - <T: NumericType> (number: T) -> T {
    return T(-number.value)
}

public func += <T :NumericType> (inout lhs: T, rhs: T) {
    lhs.value = lhs.value + rhs.value
}

public func -= <T :NumericType> (inout lhs: T, rhs: T) {
    lhs.value = lhs.value - rhs.value
}

public protocol MultiplicativeType : NumericType {
    typealias ProductType : NumericType
}

public func * < T :MultiplicativeType, P :NumericType where T.ProductType == P > (lhs: T, rhs: T) -> P {
    return P(lhs.value * rhs.value)
}

public func / < T :NumericType, Q: MultiplicativeType where Q.ProductType == T > (lhs: T, rhs: Q) -> Q {
    return Q(lhs.value / rhs.value)
}

public func sqrt <T :NumericType, R: MultiplicativeType where R.ProductType == T> (x: T) -> R {
    return R(sqrt(x.value))
}
