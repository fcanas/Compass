//
//  Polyline.swift
//  Compass
//
//  Created by Fabian Canas on 5/14/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import MapKit

public func vectorAtPolylineTail(polyline: MKPolyline) -> CGVector {
    let points = polyline.points()
    let p0 = points[polyline.pointCount - 1]
    let p1 = points[polyline.pointCount - 2]
    
    let dx = p1.x - p0.x
    let dy = p1.y - p0.y
    
    return CGVectorMake( CGFloat(dx), CGFloat(dy) )
}

public func vectorAtPolylineHead(polyline: MKPolyline) -> CGVector {
    let points = polyline.points()
    let p0 = points[0]
    let p1 = points[1]
    
    let dx = p1.x - p0.x
    let dy = p1.y - p0.y
    
    return CGVectorMake( CGFloat(dx), CGFloat(dy) )
}

