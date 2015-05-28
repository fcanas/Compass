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
    
    var route :Route?
    
    var touchPoints :[CLLocationCoordinate2D] = [] {
        didSet {
            if touchPoints.count >= 2 {
                let request = MKDirectionsRequest()
                request.transportType = MKDirectionsTransportType.Walking
                request.setSource(mapItemWithCoordinate(touchPoints[0]))
                request.setDestination(mapItemWithCoordinate(touchPoints[1]))
                
                MKDirections(request: request).calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!, error: NSError!) -> Void in
                    if let r = response.routes.first as? MKRoute {
                        self.route = Route(route:r)
                        self.mapView.addRoute(self.route!)
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
        mapView.addAnnotation(TouchPoint(coordinate: touchCoord))
        touchPoints.append(touchCoord)
    }
}
