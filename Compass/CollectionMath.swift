//
//  CollectionMath.swift
//  Compass
//
//  Created by Fabian Canas on 6/2/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public func min<T: Comparable>(a: [T]) -> T {
    return a.reduce(a.first!, combine: min)
}

public func max<T: Comparable>(a: [T]) -> T {
    return a.reduce(a.first!, combine: max)
}

public func range<T: Comparable>(a: [T]) -> (min: T, max: T) {
    return a.reduce((a.first!, a.first!), combine: { (min($0.0,$1), max($0.1, $1)) })
}

public func normalize(a: [Double]) -> [Double] {
    let (minV, maxV) = range(a)
    return a.map { ($0 - minV) / (maxV - minV) }
}
