//
//  Bool+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation

public extension String {
    
    static let empty = ""
    static let notAvailable = "N/A"
    static let dotSeparator = " · "
    
    var url: URL? {
        URL(string: self)
    }
    
    var boolValue: Bool {
        (self as NSString).boolValue
    }
    
    var snakeCased: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: .zero, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased() ?? self
    }
    
    var titleCased: String {
        replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
    
    var initials: String {
        let words = self.components(separatedBy: " ")
        
        guard words.count >= 2 else { return .empty }
        
        let firstLastName = Array(words.prefix(1) + words.suffix(1))
        
        var initials = ""
        
        for name in firstLastName {
            if let firstLetter = name.first {
                initials += String(firstLetter)
            }
        }
        return initials.uppercased()
    }
}
