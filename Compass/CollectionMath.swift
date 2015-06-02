//
//  CollectionMath.swift
//  Compass
//
//  Created by Fabian Canas on 6/2/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public func min<T: Comparable>(a: [T]) -> T {
    return reduce(a, a.first!, min)
}

public func max<T: Comparable>(a: [T]) -> T {
    return reduce(a, a.first!, max)
}

public func range<T: Comparable>(a: [T]) -> (min: T, max: T) {
    return reduce(a, (a.first!, a.first!), { (min($0.0,$1), max($0.1, $1)) })
}

public func normalize(a: [Double]) -> [Double] {
    let (minV, maxV) = range(a)
    return map(a, { ($0 - minV) / (maxV - minV) })
}
