//
//  ViewController.swift
//  Compass App
//
//  Created by Fabian Canas on 5/28/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Cocoa
import MapKit
import CompassOSX

func colorMap(value: Double) -> NSColor {
    
    let redRamp = ramp(2, -0.5)
    let greenRamp = ramp(-2, 0.9)
    let blueRamp = ramp(0, 0.3)
    println("value: \(value)")
    println("rgb: (\(redRamp(value)), \(greenRamp(value)), \(blueRamp(value))) ")
    
    
    return NSColor(
        calibratedRed: CGFloat(clamp(redRamp(value), 0, 1)),
        green: CGFloat(clamp(greenRamp(value), 0, 1)),
        blue: CGFloat(clamp(blueRamp(value), 0, 1)),
        alpha: 1.0)
}

class ViewController: NSViewController, MKMapViewDelegate {
    
    @IBOutlet var routeBuilder :RouteBuilder?
    @IBOutlet var mapView :MKMapView?
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let providenceCoord = CLLocationCoordinate2DMake(41.8305, -71.38754)
        let smallSpan = MKCoordinateSpanMake(0.018, 0.018)
        let providenceRegion = MKCoordinateRegionMake(providenceCoord, smallSpan)
        map(mapView, {$0.region = providenceRegion})
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        if let views = views as? [MKPinAnnotationView] {
            for view in views {
                view.animatesDrop = true
            }
        }
    }
    
    var trace :Trace!
    var poly :MKPolyline!
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if let overlay = overlay as? TracePolyline, let p = poly {
            let r = ColoredPathRenderer(polyline:overlay)
            
            r.colors = map(normalize(traceSegmentDistanceToMultiPoint(trace, poly)), colorMap)
            return r
        }
        
        if let polyline = overlay as? MKPolyline {
            poly = polyline
            let r = ChevronPathRenderer(polyline: polyline)
            r.color = NSColor.purpleColor()
            r.chevronColor = NSColor.cyanColor()
            return r
        }
        return nil
    }
    
    @IBAction func clearRoute(sender: AnyObject) {
        routeBuilder?.route = nil
    }
    
    @IBAction func clearMap(sender: AnyObject) {
        clearRoute(sender)
        mapView?.removeOverlays( mapView?.overlays as? [MKOverlay] )
    }
    
    @IBAction func makeTrace(sender: AnyObject) {
        let traceView = MapTraceView()
        traceView.mapView = mapView
        view.addSubview(traceView, positioned: NSWindowOrderingMode.Above, relativeTo: mapView)
        traceView.frame = mapView!.frame
        traceView.traceCompleted = { trace in
            self.trace = trace
            self.mapView?.addOverlay(trace.polyline)
        }
    }
}


import MapKit

class TracePolyline :MKPolyline {}

extension Trace {
    
    var polyline :TracePolyline {
        get {
            var coords = map(locations) { $0.coordinate }
            return TracePolyline(coordinates: &coords, count: coords.count)
        }
    }
}

