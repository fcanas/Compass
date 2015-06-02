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
import CoreGraphics

class MapTraceView: NSView {
    var mapView :MKMapView?
    
    var trace :Trace?
    
    var traceCompleted :((trace: Trace) -> Void)?
    
    private var path :CGMutablePathRef = CGPathCreateMutable()
    
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
        let point = convertPoint(theEvent.locationInWindow, fromView: nil)
        CGPathMoveToPoint(path, nil, point.x, point.y)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        let point = convertPoint(theEvent.locationInWindow, fromView: nil)
        let lastPoint = CGPathGetCurrentPoint(path)
        CGPathAddLineToPoint(path, nil, point.x, point.y)
        if let coord = mapView?.convertPoint(point, toCoordinateFromView: self) {
            trace?.insert(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
        var dirtyRect = NSRect(
            x: min(lastPoint.x, point.x),
            y: min(lastPoint.y, point.y),
            width: max(lastPoint.x, point.x) - min(lastPoint.x, point.x),
            height: max(lastPoint.y, point.y) - min(lastPoint.y, point.y))
        
        dirtyRect.inset(dx: -12, dy: -12)
        setNeedsDisplayInRect(dirtyRect)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        map(trace) {traceCompleted?(trace: $0)}
        removeFromSuperview()
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let context = NSGraphicsContext.currentContext()?.CGContext
        NSColor.greenColor().set()
        CGContextSetLineWidth(context, 12)
        CGContextAddPath(context, path)
        CGContextStrokePath(context)
    }
    
}
