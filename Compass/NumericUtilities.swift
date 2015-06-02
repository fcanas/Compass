//
//  NumericUtilities.swift
//  Compass
//
//  Created by Fabian Canas on 6/2/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public func clamp(value :Double, minimum :Double, maximum :Double) -> Double {
    return min(max(value, minimum), maximum)
}

public func ramp(m :Double, b :Double) -> (Double) -> (Double) {
    return { x in m*x + b }
}