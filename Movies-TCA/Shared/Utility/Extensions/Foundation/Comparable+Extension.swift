//
//  Comparable+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 15/12/2023.
//

import Foundation

extension Comparable {
    
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Comparable where Self: FloatingPoint {

    func percentageInside(range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            return Self(0)
        } else if self > range.upperBound {
            return Self(1)
        } else {
            let rangeWidth = range.upperBound - range.lowerBound
            let distanceFromLowerBound = self - range.lowerBound
            return distanceFromLowerBound / rangeWidth
        }
    }
}
