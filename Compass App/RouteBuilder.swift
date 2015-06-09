//
//  RouteBuilder.swift
//  Compass
//
//  Created by Fabian Canas on 5/28/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Cocoa
import MapKit
import CompassOSX

@objc class TouchPoint: NSObject, MKAnnotation {
    var coordinate :CLLocationCoordinate2D
    init (coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}

func mapItemWithCoordinate(coordinate: CLLocationCoordinate2D) -> MKMapItem {
    return MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
}

class RouteBuilder: NSObject {
    
    @IBOutlet weak var mapView :MKMapView!
    
    var route :Route? {
        didSet {
            if route == nil {
                if let r = oldValue {
                    self.mapView?.removeRoute(r)
                }
            }
        }
    }
    
    var touchPoints :[TouchPoint] = [] {
        didSet {
            if touchPoints.count >= 2 {
                let request = MKDirectionsRequest()
                request.transportType = MKDirectionsTransportType.Walking
                request.source = mapItemWithCoordinate(touchPoints[0].coordinate)
                request.destination = mapItemWithCoordinate(touchPoints[1].coordinate)
                
                MKDirections(request: request).calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) -> Void in
                    if let r = response?.routes.first {
                        self.route = Route(route:r)
                        self.mapView.addRoute(self.route!)
                        self.mapView.removeAnnotations(self.touchPoints)
                        self.touchPoints = []
                    }
                }
                
            }
        }
    }
    
    @IBAction func mapPress(sender: NSPressGestureRecognizer) {
        if sender.state != NSGestureRecognizerState.Began {
            return
        }
        
        if route != nil {
            return
        }
        
        let touchCoord = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
        let tp = TouchPoint(coordinate: touchCoord)
        mapView.addAnnotation(tp)
        touchPoints.append(tp)
    }
}
