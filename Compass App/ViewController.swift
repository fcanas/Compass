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

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if let polyline = tracePolyline, let overlay = overlay as? MKPolyline {
            if polyline == overlay {
                return traceRenderer(overlay)
            }
        }
        
        if let polyline = overlay as? MKPolyline {
            return ChevronPathRenderer(polyline: polyline)
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
            self.tracePolyline = trace.polyline
            self.mapView?.addOverlay(self.tracePolyline)
        }
    }
    
    var tracePolyline :MKPolyline?
    
    func traceRenderer(polyline: MKPolyline) -> MKOverlayRenderer {
        let r = ChevronPathRenderer(polyline: polyline)
        r.color = NSColor.greenColor().colorWithAlphaComponent(0.1)
        r.chevronColor = NSColor.greenColor()
        return r
    }
}


import MapKit

extension Trace {
    
    var polyline :MKPolyline {
        get {
            var coords = map(locations) { $0.coordinate }
            return MKPolyline(coordinates: &coords, count: coords.count)
        }
    }
}

