//
//  GeoVector.swift
//  Compass
//
//  Created by Fabian Canas on 6/3/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import CoreLocation

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
        longitude = atan( v.dy / v.dx )
        latitude = acos( v.dz / magnitude(v) )
    }
}

