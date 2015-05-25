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

protocol Route {
    var distance :CLLocationDistance { get }
    var polyline :MKPolyline! { get }
    var steps :[AnyObject]! { get }
    var routeSteps :[RouteStep] { get }
}

protocol RouteStep {
    var instructions :String! { get }
    var polyline :MKPolyline! { get }
}

extension MKRouteStep :RouteStep {
    
}

extension MKRoute :Route {
    var routeSteps :[RouteStep] {
        get {
            return steps as! [MKRouteStep]
        }
    }
}

class Copilot {
    private let route :Route
    private var trace :Trace
    
    func addLocation(location: CLLocation) {
        trace.insert(location)
    }
    
    func addLocations(locations: SequenceOf<CLLocation>) {
        map(locations, trace.insert)
    }
    
    init(route: Route) {
        trace = Trace()
        self.route = route
    }
}