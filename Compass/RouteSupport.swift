//
//  RouteSupport.swift
//  Compass
//
//  Created by Fabian Canas on 5/24/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation
import MapKit

func traceToMultiPoint(trace: Trace, multiPoint: MKMultiPoint) {
    var matrix = map(trace, { multiPoint.distance($0) } )
}