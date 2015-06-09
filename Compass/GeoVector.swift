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
    return Radian(atan2(sin(lng2 - lng1) * cos(lat2), cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(lng2-lng1)))
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

func distance(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D) -> CLLocationDistance {
    let angularDistance :Radian = distance(c1, c2: c2)
    return angularDistance.value * 6373000
}

func distance(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D) -> Radian {
    let (lat1, lng1) = c1.asRadians
    let (lat2, lng2) = c2.asRadians

    let dLat_2 = (lat1 - lat2).value/2
    let dLng_2 = (lng1 - lng2).value/2
    let a = sin(dLat_2) * sin(dLat_2) + sin(dLng_2) * sin(dLng_2) * cos(lat1) * cos(lat2)
    return Radian(2 * atan2(sqrt(a), sqrt(1-a)))
}
