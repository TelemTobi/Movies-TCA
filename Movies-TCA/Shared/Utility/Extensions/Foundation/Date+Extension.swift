//
//  Date+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import Foundation

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