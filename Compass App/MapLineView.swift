//
//  MapLineView.swift
//  Compass
//
//  Created by Fabian Canas on 6/15/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Cocoa
import MapKit
import CoreLocation

extension NSPoint {
    func rectByAddingPoint(point: NSPoint) -> NSRect {
        return NSRect(
            x: min(x, point.x),
            y: min(y, point.y),
            width: max(x, point.x) - min(x, point.x),
            height: max(y, point.y) - min(y, point.y))
    }
}

extension NSRect {
    var maxPoint :NSPoint {
        return NSPoint(x: origin.x + size.width, y: origin.y + size.height)
    }
    
    func rectByAddingPoint(point: NSPoint) -> NSRect {
        return NSRect(
            x: min(origin.x, point.x),
            y: min(origin.y, point.y),
            width: max(maxPoint.x, point.x) - min(origin.x, point.x),
            height: max(maxPoint.y, point.y) - min(origin.y, point.y))
    }
}

class MapLineView: NSView {

    var mapView :MKMapView?
    
    var startPoint :NSPoint!
    var priorEndPoint :NSPoint?
    var endPoint :NSPoint?
    
    var lineCompleted :((start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> Void)?
    
    override var acceptsFirstResponder :Bool {
        get {
            return true
        }
    }
    
    override func acceptsFirstMouse(theEvent: NSEvent) -> Bool {
        return true
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let point = convertPoint(theEvent.locationInWindow, fromView: nil)
        startPoint = point
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        
        priorEndPoint = endPoint
        endPoint = convertPoint(theEvent.locationInWindow, fromView: nil)
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y)
        CGPathAddLineToPoint(path, nil, point.x, point.y)
        
        if let coord = mapView?.convertPoint(point, toCoordinateFromView: self) {
            trace?.insert(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
        
        
        
//        var dirtyRect = NSRect(
//            x: min(lastPoint.x, point.x),
//            y: min(lastPoint.y, point.y),
//            width: max(lastPoint.x, point.x) - min(lastPoint.x, point.x),
//            height: max(lastPoint.y, point.y) - min(lastPoint.y, point.y))
        
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
