//
//  Numeric+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 01/12/2023.
//

import Foundation

extension Numeric {
    
    var asPercentage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter.string(from: Double(truncating: self as! NSNumber) as NSNumber) ?? ""
    }
    
    var abbreviation: String {
        let num = Double(truncating: self as! NSNumber)
        let sign = ((num < 0) ? "-" : "" )
        let absNum = abs(num)
        let abbrev = ["", "K", "M", "B", "T", "P", "E"]
        var index = 0
        var numFormat = absNum
        while numFormat >= 1000 && index < abbrev.count - 1 {
            numFormat /= 1000.0
            index += 1
        }
        var numString = "\(numFormat)"
        if numFormat.truncatingRemainder(dividingBy: 1) == 0 {
            numString = String(format: "%.0f", numFormat)
        } else {
            numString = String(format: "%.1f", numFormat)
        }
        return "\(sign)\(numString)\(abbrev[index])"
    }
}
