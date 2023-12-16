//
//  Int+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/12/2023.
//

import Foundation

extension Int {
    
    var zero: Int { 0 }
    
    var durationInHoursAndMinutesShortFormat: String {
        let hours = self / 60
        let minutes = self % 60
        return "\(hours)h \(minutes)m"
    }
}
