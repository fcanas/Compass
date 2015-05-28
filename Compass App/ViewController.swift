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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        if let views = views as? [MKPinAnnotationView] {
            for view in views {
                view.animatesDrop = true
            }
        }
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if let polyline = overlay as? MKPolyline {
            return ChevronPathRenderer(polyline: polyline)
        }
        return nil
    }
}

