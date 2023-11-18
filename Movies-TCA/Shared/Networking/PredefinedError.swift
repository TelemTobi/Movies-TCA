//
//  PredefinedError.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

enum PredefinedError: String, Error {
    case connectionError
    case authError
    case decodingError
    case unkownError
    
    var debugDescription: String {
        self.rawValue.titleCased
    }
}
