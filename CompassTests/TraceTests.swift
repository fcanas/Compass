//
//  TraceTests.swift
//  Compass
//
//  Created by Fabian Canas on 5/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit
import XCTest
import Compass
import CoreLocation

class TraceTests: XCTestCase {
    let coord = CLLocationCoordinate2DMake(24, 44)
    var trace :Trace = Trace(locations: [])
    
    lazy var l1 :CLLocation = CLLocation(coordinate: self.coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate(timeIntervalSinceReferenceDate: 100))
    lazy var l2 :CLLocation = CLLocation(coordinate: self.coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate(timeIntervalSinceReferenceDate: 200))
    lazy var l3 :CLLocation = CLLocation(coordinate: self.coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate(timeIntervalSinceReferenceDate: 300))
    lazy var l4 :CLLocation = CLLocation(coordinate: self.coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: NSDate(timeIntervalSinceReferenceDate: 400))

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTraceConstruction() {
        trace = Trace(locations: [l2,l1,l4])
        
        XCTAssertEqual(trace.locations, [l1,l2,l4], "Trace should sort constructor arguments by date")
    }
    
    func testTraceInsertion() {
        var trace = Trace(locations: [l1,l2,l4])
        trace.insert(l3)
        
        XCTAssertEqual(trace.locations, [l1,l2,l3,l4], "Trace insert locations mid-collection correctly")
        
        trace = Trace(locations: [l1,l2,l3])
        trace.insert(l4)
        XCTAssertEqual(trace.locations, [l1,l2,l3,l4], "Trace insert locations correctly at the end")
        trace = Trace(locations: [l2,l3,l4])
        trace.insert(l1)
        XCTAssertEqual(trace.locations, [l1,l2,l3,l4], "Trace insert locations correctly at the beginning")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
