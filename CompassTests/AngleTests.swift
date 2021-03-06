//
//  AngleTests.swift
//  Compass
//
//  Created by Fabian Canas on 5/15/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation
import XCTest
import Compass

class AngleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDegreeToRadianConversion() {
        XCTAssertEqual(Radian(0), Radian(angle:Degree(0)), "Zero degrees to radians via specific constructor should equal zero radians")
        
        XCTAssertEqualWithAccuracy(Radian(M_PI).value, Radian(angle:Degree(180)).value, 0.00001, "180 degrees should convert to radians")
        XCTAssertEqualWithAccuracy(Radian(2 * M_PI).value, Radian(angle:Degree(360)).value, 0.00001, "360 degrees should convert to radians")
    }
    
    func testRadianToDegreeConversion() {
        XCTAssertEqual(Degree(0), Degree(angle:Radian(0)), "Zero degrees to radians via specific constructor should equal zero radians")
        
        XCTAssertEqualWithAccuracy(Degree(180).value, Degree(angle:Radian(M_PI)).value, 0.00001, "π radians should convert to degrees")
        XCTAssertEqualWithAccuracy(Degree(360).value, Degree(angle:Radian(2 * M_PI)).value, 0.00001, "2π radians should convert to degrees")
    }
    
    func testRadianArithmetic() { arithmeticTests(Radian)() }
    
    func testDegreeArithmetic() { arithmeticTests(Degree)() }
    
    func testUnwindRadians() {
        let _2π = M_PI * 2
        XCTAssertEqual(unwindAngle(Radian(1.75 + 3 * _2π)), Radian(1.75), "Radians should unwind to within a single turn of a circle")
        XCTAssertEqual(unwindAngle(Radian(1.75 - 7 * _2π)), Radian(1.75), "Negative Radians should unwind to within a single turn of a circle (positive)")
    }
    
    func testUnwindDegrees() {
        let _2π = 360.0
        XCTAssertEqual(unwindAngle(Degree(84.75 + 3 * _2π)), Degree(84.75), "Degrees should unwind to within a single turn of a circle")
        XCTAssertEqual(unwindAngle(Degree(99.75 - 7 * _2π)), Degree(99.75), "Negative Degrees should unwind to within a single turn of a circle (positive)")
    }
    
    func testUnwindShouldBePositiveDegrees() { unwindPositive(Degree)() }
    
    func testUnwindShouldBePositiveRadians() { unwindPositive(Radian)() }
    
    func testAbsoluteValue() {
        XCTAssertEqual(abs(Degree(-12)), Degree(12), "Absolute value should work on Degrees")
        XCTAssertEqual(abs(Radian(-19)), Radian(19), "Absolute value should work on Radians")
        
        XCTAssertEqual(abs(Degree(12)), Degree(12), "Absolute value should ignore positives on Degrees")
        XCTAssertEqual(abs(Radian(19)), Radian(19), "Absolute value shoud ignore positives on Radians")
    }
    
    func testDegreesFloatLiteral() { floatLiteral(Degree)() }
    
    func testRadiansFloatLiteral() { floatLiteral(Radian)() }
    
    func testDegreesIntegerLiteral() { integerLiteral(Degree)() }
    
    func testRadiansIntegerLiteral() { integerLiteral(Radian)() }
    
    func testDegreeTrigonometry() {
        let eps = 0.0000001
        
        XCTAssertEqual(sin(Degree(0)), 0, "sin of 0 degrees should be zero")
        XCTAssertEqual(sin(Degree(90)), 1, "sin of 90 degrees should be 1")
        XCTAssertEqual(sin(Degree(45)), 1/sqrt(2), "sin of 45 degrees should be 1/sqrt(2)")
        
        XCTAssertEqual(cos(Degree(0)), 1, "cos of 0 degrees should be 1")
        XCTAssertEqualWithAccuracy(cos(Degree(90)), 0, eps, "cos of 90 degrees should be 0")
        XCTAssertEqualWithAccuracy(cos(Degree(45)), 1/sqrt(2), eps, "cos of 45 degrees should be 1/sqrt(2)")
        
        XCTAssertEqual(tan(Degree(0)), 0, "tan of 0 degrees should be 1")
        XCTAssertEqualWithAccuracy(tan(Degree(30)), 1/sqrt(3), eps, "tan of 30 degrees should be 1/sqrt(3)")
        XCTAssertEqualWithAccuracy(tan(Degree(45)), 1, eps, "tan of 45 degrees should be 1")
    }
}

func floatLiteral <T: Angle> (type: T.Type) -> Void -> Void {
    return {
        let angle1 :T = 1.75
        let angle2 :T = 180.33
        XCTAssertEqual(angle1, T(1.75), "Literal angle should be equal to constructed angle")
        XCTAssertEqual(angle2, T(180.33), "Literal angle should be equal to constructed angle")
    }
}

func integerLiteral <T: Angle> (type: T.Type) -> Void -> Void {
    return {
        let angle1 :T = 10
        let angle2 :T = 180
        XCTAssertEqual(angle1, T(10), "Literal angle should be equal to constructed angle")
        XCTAssertEqual(angle2, T(180.0), "Literal angle should be equal to constructed angle")
    }
}

func unwindPositive <T: Angle> (type: T.Type) -> Void -> Void {
    return {
        for var i = 0; i < 100; i++ {
            XCTAssertGreaterThanOrEqual(unwindAngle(T(Double(arc4random()))).value, 0, "Unwound angles should be greater than zero")
        }
    }
}

func arithmeticTests <T: Angle> (type: T.Type) -> Void -> Void {
    return {
        let a3 = T(3)
        let a4 = T(4)
        XCTAssertEqual(a3 + a4, T(7), "Angles should be summable")
        XCTAssertEqual(a3 - a4, T(-1), "Angles should be subtractable")
        
        var a = T(1.5)
        a += a3
        XCTAssertEqual(a, T(4.5), "Mutable Angles should accept +=")
        a -= a4
        XCTAssertEqual(a, T(0.5), "Mutable Angles should accept -=")
        
        XCTAssertEqual(a4 % a3, T(1), "Angles should accept modular arithmetic")
        XCTAssertEqual(T(20.25) % T(7.5), T(5.25), "Angles should accept floating point modular arithmetic")
    }
}
