//
//  ApiError.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

enum ApiError: String, Errorable {
    case badRequest
    case serverError
    case decodingError
    case unkownError
    
    var debugDescription: String {
        self.rawValue
    }
}
