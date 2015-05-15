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
    
    func testAbsoluteValue() {
        XCTAssertEqual(abs(Degree(-12)), Degree(12), "Absolute value should work on Degrees")
        XCTAssertEqual(abs(Radian(-19)), Radian(19), "Absolute value shou;d work on Radians")
        
        XCTAssertEqual(abs(Degree(12)), Degree(12), "Absolute value should ignore positives on Degrees")
        XCTAssertEqual(abs(Radian(19)), Radian(19), "Absolute value shoud ignore positives on Radians")
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
