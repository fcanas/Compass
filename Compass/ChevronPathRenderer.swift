//
//  ChevronPathRenderer.swift
//  Compass
//
//  Created by Fabian Canas on 5/27/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import MapKit
import CoreGraphics

#if os(OSX)
    public typealias CMPSColor = NSColor
    #else
    public typealias CMPSColor = UIColor
#endif

public class ChevronPathRenderer: MKOverlayRenderer {
    public var color: CMPSColor = CMPSColor(red: 0xff/255.0, green: 0x85/255.0, blue: 0x1b/255.0, alpha: 1)
    public var chevronColor: CMPSColor = CMPSColor(red: 0xff/255.0, green: 0x41/255.0, blue: 0x36/255.0, alpha: 1)
    public let polyline: MKPolyline
    public var lineWidth: CGFloat = 12
    
    public init(polyline: MKPolyline) {
        self.polyline = polyline
        super.init(overlay: polyline)
        setNeedsDisplayInMapRect(polyline.boundingMapRect)
    }
    
    public override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        if !MKMapRectIntersectsRect(mapRect, MKMapRectInset(polyline.boundingMapRect, -20, -20)) {
            return
        }
        
        let path = CGPathCreateMutable()
        let chevronPath = CGPathCreateMutable()
        let firstPoint = pointForMapPoint(polyline.points()[0])
        
        
        let ctxLineWidth = CGContextConvertSizeToUserSpace(context, CGSizeMake(lineWidth, lineWidth)).width * contentScaleFactor
        let ctxPixelWidth = CGContextConvertSizeToUserSpace(context, CGSizeMake(1, 1)).width * contentScaleFactor
        
        CGPathMoveToPoint(path, nil, firstPoint.x, firstPoint.y)
        CGPathMoveToPoint(chevronPath, nil, firstPoint.x, firstPoint.y)
        
        var offset: CGFloat = 0.0
        for idx in 1...(polyline.pointCount - 1) {
            let nextPoint = pointForMapPoint(polyline.points()[idx])
            CGPathAddLineToPoint(path, nil, nextPoint.x, nextPoint.y)
            offset = chevronToPoint(chevronPath, point: nextPoint, size: ctxLineWidth, offset: offset)
        }
        
        CGContextSetLineJoin(context, .Round)
        CGContextSetLineCap(context, .Round)
        
        CGContextAddPath(context, path)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetLineWidth(context, ctxLineWidth)
        CGContextStrokePath(context)
        
        CGContextSetLineJoin(context, .Miter)
        CGContextSetLineCap(context, .Square)
        
        CGContextAddPath(context, chevronPath)
        CGContextSetFillColorWithColor(context, chevronColor.CGColor)
        CGContextSetLineWidth(context, ctxPixelWidth)
        CGContextFillPath(context)
    }
    
    private func pointDist(point1: CGPoint!, point2: CGPoint!) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2.0) + pow(point1.y - point2.y, 2.0))
    }
    
    private func chevronToPoint(path: CGMutablePathRef!, point: CGPoint, size: CGFloat!, offset: CGFloat) -> CGFloat {
        
        let startingPoint = CGPathGetCurrentPoint(path)
        
        let dx = point.x - startingPoint.x
        let dy = point.y - startingPoint.y
        
        let w: CGFloat = size / 2
        let h: CGFloat = size / 3
        
        // Create Transform for Chevron
        var t = CGAffineTransformMakeTranslation(startingPoint.x, startingPoint.y)
        t = CGAffineTransformRotate(t, -atan2(dx, dy))
        t = CGAffineTransformTranslate(t, 0, offset)
        
        var overshoot = offset
        while overshoot < pointDist(startingPoint, point2: point) {
            CGPathMoveToPoint   (path, &t,  0,  0)
            CGPathAddLineToPoint(path, &t,  w, -h)
            CGPathAddLineToPoint(path, &t,  w,  0)
            CGPathAddLineToPoint(path, &t,  0,  h)
            CGPathAddLineToPoint(path, &t, -w,  0)
            CGPathAddLineToPoint(path, &t, -w, -h)
            CGPathAddLineToPoint(path, &t,  0,  0)
            
            t = CGAffineTransformTranslate(t, 0, 3 * h)
            overshoot += 3 * h
        }
        overshoot -= pointDist(startingPoint, point2: point)
        
        CGPathMoveToPoint(path, nil, point.x, point.y)
        
        return overshoot
    }
}