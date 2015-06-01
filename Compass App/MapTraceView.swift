//
//  MapTraceView.swift
//  Compass
//
//  Created by Fabian Canas on 6/1/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Cocoa
import MapKit
import CompassOSX

class MapTraceView: NSView {

    var mapView :MKMapView?
    
    var trace :Trace?
    
    var traceCompleted :((trace: Trace) -> Void)?
    
    override var acceptsFirstResponder :Bool {
        get {
            return true
        }
    }
    
    override func acceptsFirstMouse(theEvent: NSEvent) -> Bool {
        return true
    }
    
    override func mouseDown(theEvent: NSEvent) {
        trace = Trace()
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        let point = convertPoint(theEvent.locationInWindow, fromView: nil)
        if let coord = mapView?.convertPoint(point, toCoordinateFromView: self) {
            trace?.insert(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        map(trace) {traceCompleted?(trace: $0)}
        removeFromSuperview()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
}
