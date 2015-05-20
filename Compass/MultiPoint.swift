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
