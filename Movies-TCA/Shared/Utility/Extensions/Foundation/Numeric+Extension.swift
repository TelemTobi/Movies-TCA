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
}
