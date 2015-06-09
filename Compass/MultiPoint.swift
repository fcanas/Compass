//
//  MultiPoint.swift
//  Compass
//
//  Created by Fabian Canas on 5/20/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import MapKit
import CoreLocation

extension MKMultiPoint: SequenceType {
    public typealias Generator = AnyGenerator<MKMapPoint>
    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
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

func pointDistanceToSegment(point: CLLocationCoordinate2D, segment: (CLLocationCoordinate2D, CLLocationCoordinate2D)) -> CLLocationDistance {
    let radius_of_earth :Double = 6371008 // Roughly from WGS84
    
    let d13 :Radian = distance(segment.0, c2: point)
    let bearing13 = bearing(segment.0, end: point)
    let bearing12 = bearing(segment.0, end: segment.1)
    
    return asin(sin(d13) * sin(bearing13 - bearing12)) * radius_of_earth
//    let N = normalize(cross(Vector3(coordinate: segment.0), Vector3(coordinate: segment.1)))
//    return acos( dot(N, Vector3(coordinate: point)) ) * radius_of_earth
}

extension MKMultiPoint {
    /// Given an MKMultiPoint and a coordinate, returns an array of the distance from the supplied coordinate to each point in the polyline.
    public func distance(toCoordinate: CLLocationCoordinate2D) -> [CLLocationDistance] {
        let mkCoordinate = MKMapPointForCoordinate(toCoordinate)
        return self.map { MKMetersBetweenMapPoints($0, mkCoordinate) }
    }
    
    /// Given an MKMultiPoint and a CLLocation, returns an array of the distance from the supplied location and error to each point in the polyline.
    public func distance(toLocation: CLLocation) -> [(CLLocationDistance, CLLocationAccuracy)] {
        let mkCoordinate = MKMapPointForCoordinate(toLocation.coordinate)
        let mkError = toLocation.horizontalAccuracy
        return self.map { (MKMetersBetweenMapPoints($0, mkCoordinate), mkError) }
    }
    
    /// Given an MKMultiPoint and a CLLocation, returns an array of the distance from the supplied location and error to segments between each point on the polyline.
    /// returns an array with 1 fewer element than the number of points in the multiline
    public func segmentDistance(toLocation: CLLocation) -> [(CLLocationDistance, CLLocationAccuracy)] {
        let coordinate = toLocation.coordinate
        let error = toLocation.horizontalAccuracy
        
        let coordinates = GeneratorSequence(self.generate()).map( MKCoordinateForMapPoint )
        
        var advanceGenerator = coordinates.generate()
        advanceGenerator.next()
        let segments = Array(GeneratorSequence(ZipGenerator2(coordinates.generate(), advanceGenerator)))
        return segments.map { (pointDistanceToSegment(coordinate, segment: $0), error) }
    }
}
