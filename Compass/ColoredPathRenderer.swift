//
//  ColoredPathRenderer.swift
//  Compass
//
//  Created by Fabian Canas on 6/2/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import MapKit

public class ColoredPathRenderer: MKOverlayRenderer {
    private var color: CMPSColor = CMPSColor.blackColor().colorWithAlphaComponent(0.2)
    public var colors: [CMPSColor]?
    public let polyline: MKPolyline
    public var lineWidth: CGFloat = 12
    
    public init(polyline: MKPolyline) {
        self.polyline = polyline
        super.init(overlay: polyline)
        setNeedsDisplayInMapRect(polyline.boundingMapRect)
    }
    
    public override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext!) {
        if !MKMapRectIntersectsRect(mapRect, MKMapRectInset(polyline.boundingMapRect, -20, -20)) {
            return
        }
        
        var lastPoint = pointForMapPoint(polyline.points()[0])
        
        let ctxLineWidth = CGContextConvertSizeToUserSpace(context, CGSizeMake(lineWidth, lineWidth)).width * contentScaleFactor
        let ctxPixelWidth = CGContextConvertSizeToUserSpace(context, CGSizeMake(1, 1)).width * contentScaleFactor
        
        var offset: CGFloat = 0.0
        for idx in 1...(polyline.pointCount - 1) {
            let path = CGPathCreateMutable()
            let chevronPath = CGPathCreateMutable()
            
            CGPathMoveToPoint(path, nil, lastPoint.x, lastPoint.y)
            CGPathMoveToPoint(chevronPath, nil, lastPoint.x, lastPoint.y)
            
            let nextPoint = pointForMapPoint(polyline.points()[idx])
            CGPathAddLineToPoint(path, nil, nextPoint.x, nextPoint.y)
            lastPoint = CGPathGetCurrentPoint(path)
            offset = chevronToPoint(chevronPath, point: nextPoint, size: ctxLineWidth, offset: offset)
            
            CGContextSetLineJoin(context, kCGLineJoinMiter)
            CGContextSetLineCap(context, kCGLineCapSquare)
            
            CGContextAddPath(context, chevronPath)
            
            if colors == nil || idx >= colors?.count ?? 0 {
                CGContextSetFillColorWithColor(context, CMPSColor.blackColor().CGColor)
            } else {
                CGContextSetFillColorWithColor(context, colors![idx].CGColor)
            }
            
            CGContextSetLineWidth(context, ctxPixelWidth)
            CGContextFillPath(context)
        }
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
        
        let count = Int( (pointDist(startingPoint, point2: point) - offset) / (2.0 * h) ) * 2 / 3
        
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

