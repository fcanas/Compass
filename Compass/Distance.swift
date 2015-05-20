//
//  Distance.swift
//  Compass
//
//  Created by Fabian Canas on 5/20/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public struct Distance :NumericType {
    public var value :Double
    public init(_ value: Double) {
        self.value = value
    }
}

extension Distance :IntegerLiteralConvertible {
    public init(integerLiteral: IntegerLiteralType) {
        self.init(Double(integerLiteral))
    }
}

extension Distance :FloatLiteralConvertible {
    public init(floatLiteral: FloatLiteralType) {
        self.init(Double(floatLiteral))
    }
}

public struct Area :NumericType {
    public var value :Double
    public init(_ value: Double) {
        self.value = value
    }
}

extension Area :IntegerLiteralConvertible {
    public init(integerLiteral: IntegerLiteralType) {
        self.init(Double(integerLiteral))
    }
}

extension Area :FloatLiteralConvertible {
    public init(floatLiteral: FloatLiteralType) {
        self.init(Double(floatLiteral))
    }
}

extension Distance :MultiplicativeType {
    typealias ProductType = Area
}
