//
//  Geometry.swift
//  Compass
//
//  Created by Fabian Canas on 5/14/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

/// Given an angle in radians, unwinds the angle around a circle to return an angle in the range [0, 2π)
func unwindAngle(angle: Double) -> Double {
    var unwoundAngle = angle % ( 2 * M_PI )
    if unwoundAngle < 0 {
        unwoundAngle += 2 * M_PI
    }
    return unwoundAngle
}

func unwindAngle(angle: CGFloat) -> CGFloat {
    let twoπ = CGFloat( 2 * M_PI )
    var unwoundAngle = angle % twoπ
    if unwoundAngle < 0 {
        unwoundAngle += twoπ
    }
    return unwoundAngle
}

func unwindAngle(angle: Float) -> Float {
    let twoπ = Float( 2 * M_PI )
    var unwoundAngle = angle % twoπ
    if unwoundAngle < 0 {
        unwoundAngle += twoπ
    }
    return unwoundAngle
}