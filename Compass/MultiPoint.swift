//
//  MultiPoint.swift
//  Compass
//
//  Created by Fabian Canas on 5/20/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import MapKit

extension MKMultiPoint: SequenceType {
    public typealias Generator = GeneratorOf<MKMapPoint>
    public func generate() -> Generator {
        var index = 0
        return GeneratorOf {
            if index < self.pointCount {
                return self.points()[index++]
            }
            return nil
        }
    }
}

extension MKMultiPoint: CollectionType {
    typealias Index = Int
    public var startIndex :Int {
        return 0
    }
    public var endIndex :Int {
        return pointCount
    }
    public subscript(i: Int) -> MKMapPoint {
        return points()[i]
    }
}

/// Given an MKMultiPoint and a coordinate, returns an array of the distance from the supplied coordinate to each point in the polyline.

extension MKMultiPoint {
    public func distance(toCoordinate: CLLocationCoordinate2D) -> [CLLocationDistance] {
        let mkCoordinate = MKMapPointForCoordinate(toCoordinate)
        return map(self) { MKMetersBetweenMapPoints($0, mkCoordinate) }
    }
}
