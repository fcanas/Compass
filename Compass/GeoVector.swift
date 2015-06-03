//
//  GeoVector.swift
//  Compass
//
//  Created by Fabian Canas on 6/3/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import CoreLocation

func bearing(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D)  -> Radian {
    let (lat1, lng1) = start.asRadians
    let (lat2, lng2) = end.asRadians
    return Radian(atan2(sin(lng1 - lng2) * cos(lat2), cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(lng1-lng2)))
}

extension Vector3 {
    public init(coordinate: CLLocationCoordinate2D) {
        let latitude :Radian = Radian(angle: Degree(coordinate.latitude))
        let longitude :Radian = Radian(angle: Degree(coordinate.longitude))
        dx = sin(longitude) * cos(latitude)
        dy = cos(longitude) * cos(latitude)
        dz = sin(latitude)
    }
}

extension CLLocationCoordinate2D {
    init(v: Vector3) {
        longitude = Degree(angle:Radian(atan2( v.dy, v.dx ))).value
        latitude = Degree(angle: Radian(acos( v.dz / magnitude(v) ))).value
        assert(CLLocationCoordinate2DIsValid(self), "Making an invalid coordinate from a vector")
    }
    
    var asRadians :(latitude: Radian, longitude: Radian){
        get {
            return (latitude: Radian(angle:Degree(self.latitude)), longitude: Radian(angle:Degree(self.latitude)))
        }
    }
}

