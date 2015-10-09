//
//  IntersectionVisualizer.swift
//  Compass
//
//  Created by Fabian Canas on 6/15/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Cocoa
import MapKit

class IntersectionVisualizer: NSObject {
    @IBOutlet weak var mapView :MKMapView!
    
    
    @IBAction func mapPress(sender: NSPressGestureRecognizer) {
        if sender.state != NSGestureRecognizerState.Began {
            return
        }
        
        
        let touchCoord = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
        let tp = TouchPoint(coordinate: touchCoord)
        mapView.addAnnotation(tp)
        
    }
}
