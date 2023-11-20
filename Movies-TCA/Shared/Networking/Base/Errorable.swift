//
//  Errorable.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

protocol Errorable: Error, Decodable, JsonResolver {
    
    var debugDescription: String { get }
    init(_ errorType: PredefinedError)
}

enum PredefinedError: String, Error {
    case connectionError
    case authError
    case decodingError
    case unknownError
    
    var debugDescription: String {
        self.rawValue.titleCased
    }
}
