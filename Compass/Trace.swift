//
//  Trace.swift
//  Compass
//
//  Created by Fabian Canas on 5/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation
import CoreLocation

public struct Trace {
    private var _locations :[CLLocation]

    public var locations :[CLLocation] {
        return _locations
    }
    
    public init(locations: [CLLocation]) {
        _locations = locations.sorted { (a, b) -> Bool in
            return a.timestamp.compare(b.timestamp) == NSComparisonResult.OrderedAscending
        }
    }
    
    public mutating func insert(location: CLLocation) {
        var index = _locations.count
        var reverseLocationsGenerator = lazy(_locations).reverse().generate()
        while (reverseLocationsGenerator.next()?.timestamp.compare(location.timestamp) != .OrderedAscending && index > locations.startIndex) {
            --index
        }
        _locations.insert(location, atIndex: index)
    }
}
