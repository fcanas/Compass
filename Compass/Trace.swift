//
//  Trace.swift
//  Compass
//
//  Created by Fabian Canas on 5/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation
import CoreLocation

public struct Trace :SequenceType {
    public typealias Generator = GeneratorOf<CLLocation>
    
    public func generate() -> Generator {
        var index = 0
        return GeneratorOf {
            if index < self._locations.count {
                return self._locations[index++]
            }
            return nil
        }
    }
    
    private var _locations :[CLLocation] = []

    public var locations :[CLLocation] {
        return _locations
    }
    
    public init() {}
    
    /// Creates a Trace from an Array of locations by sorting the locations in temporal order
    public init(locations: [CLLocation]) {
        _locations = locations.sorted { (a, b) -> Bool in
            return a.timestamp.compare(b.timestamp) == NSComparisonResult.OrderedAscending
        }
    }
    
    /// Inserts a CLLocation into the Trace, maintaining temporal order.
    public mutating func insert(location: CLLocation) {
        var index = _locations.count
        var reverseLocationsGenerator = lazy(_locations).reverse().generate()
        while (reverseLocationsGenerator.next()?.timestamp.compare(location.timestamp) != .OrderedAscending && index > locations.startIndex) {
            --index
        }
        _locations.insert(location, atIndex: index)
    }
}

