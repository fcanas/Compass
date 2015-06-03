//
//  GeoVectorTests.swift
//  Compass
//
//  Created by Fabian Canas on 6/3/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import XCTest
import Compass
import CoreLocation

class GeoVectorTests: XCTestCase {
    
    func testWorldVector() {
        let eps = 0.000001
        
        let zeroCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        let northPole = CLLocationCoordinate2D(latitude: 90, longitude: 0)
        let southPole = CLLocationCoordinate2D(latitude: -90, longitude: 0)
        
        let ninetyEast = CLLocationCoordinate2D(latitude: 0, longitude: 90)
        let ninetyWest = CLLocationCoordinate2D(latitude: 0, longitude: -90)
        
        let dateline = CLLocationCoordinate2D(latitude: 0, longitude: 180)
        
        let zero = Vector3(coordinate: zeroCoord)
        let north = Vector3(coordinate: northPole)
        let south = Vector3(coordinate: southPole)
        let east = Vector3(coordinate: ninetyEast)
        let west = Vector3(coordinate: ninetyWest)
        let date = Vector3(coordinate: dateline)
        
        XCTAssertEqualWithAccuracy(magnitude(Vector3(dx: 0, dy: 1, dz: 0) - zero), 0, eps, "Zero coordinate should point out along y")
        XCTAssertEqualWithAccuracy(magnitude(Vector3(dx: 0, dy: 0, dz: 1) - north), 0, eps, "North should point up along z")
        XCTAssertEqualWithAccuracy(magnitude(Vector3(dx: 0, dy: 0, dz: -1) - south), 0, eps, "South should point down along z")
        XCTAssertEqualWithAccuracy(magnitude(Vector3(dx: 1, dy: 0, dz: 0) - east), 0, eps, "East should point out along x")
        XCTAssertEqualWithAccuracy(magnitude(Vector3(dx: -1, dy: 0, dz: 0) - west), 0, eps, "West should point back along x")
        XCTAssertEqualWithAccuracy(magnitude(Vector3(dx: 0, dy: -1, dz: 0) - date), 0, eps, "Internation date line should point back along y")
    }
    
}
