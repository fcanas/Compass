//
//  NumericUtilities.swift
//  Compass
//
//  Created by Fabian Canas on 6/2/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public func clamp<T :Comparable>(value :T, minimum :T, maximum :T) -> T {
    return min(max(value, minimum), maximum)
}

public func ramp(m :Double, _ b :Double) -> (Double) -> (Double) {
    return { x in m * x + b }
}
