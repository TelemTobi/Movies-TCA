//
//  Date+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import Foundation

extension Date {
    
    enum DateFormat: String {
        case dMMMyyyy = "d MMM yyyy"
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    func description(withFormat format: DateFormat, language: Preferences.Language = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = language.locale
        return dateFormatter.string(from: self)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    
    static var tmdbDateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-mm-DD"
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Failed decoding date\(dateString)")
        }
    }
}
