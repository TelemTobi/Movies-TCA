//
//  ApiError.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation

enum ApiError: Error {
    case badRequest
    case serverError
    case decodingError
}
