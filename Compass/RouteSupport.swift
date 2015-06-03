//
//  RouteSupport.swift
//  Compass
//
//  Created by Fabian Canas on 5/24/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

func traceToMultiPoint(trace: Trace, multiPoint: MKMultiPoint) {
    var matrix = map(trace, { multiPoint.distance($0) } )
}

public func traceDistanceToMultiPoint(trace: Trace, multiPoint: MKMultiPoint) -> [Double] {
    return map(trace, { loc in reduce(multiPoint.distance(loc), 10000000, { min($0, $1.0)}) } )
}

public func traceSegmentDistanceToMultiPoint(trace: Trace, multiPoint: MKMultiPoint) -> [Double] {
    return map(trace, { loc in reduce(multiPoint.segmentDistance(loc), 10000000, { min($0, $1.0)}) } )
}

public struct Route {
    var distance :CLLocationDistance
    var polyline :MKPolyline
    var steps :[RouteStep]
    
    public init(route: MKRoute) {
        distance = route.distance
        polyline = route.polyline
        steps = map(route.steps as? [MKRouteStep] ?? [], { RouteStep(routeStep: $0) })
    }
}

public class RouteStep :NSObject, MKAnnotation {
    
    public var coordinate :CLLocationCoordinate2D
    public var title :String {
        get {
            return instructions
        }
    }
    
    public var instructions :String
    public var polyline :MKPolyline
    public var distance :Distance
    
    init(routeStep: MKRouteStep) {
        self.instructions = routeStep.instructions
        self.distance = Distance(routeStep.distance)
        self.polyline = routeStep.polyline
        self.coordinate = MKCoordinateForMapPoint(polyline.points()[polyline.pointCount - 1])
    }
}

public extension MKMapView {
    public func addRoute(route: Route) {
        for step in route.steps {
            addRouteStep(step)
        }
        addOverlay(route.polyline)
    }
    
    public func removeRoute(route: Route) {
        for step in route.steps {
            removeRouteStep(step)
        }
        removeOverlay(route.polyline)
    }
    
    public func addRouteStep(routeStep: RouteStep) {
        addAnnotation(routeStep)
    }
    
    public func removeRouteStep(routeStep: RouteStep) {
        removeAnnotation(routeStep)
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