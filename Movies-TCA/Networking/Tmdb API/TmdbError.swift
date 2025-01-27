//
//  ApiError.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import Networking

struct TmdbError: DecodableError, Equatable {
    
    let statusCode: Int?
    let developerMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case developerMessage = "status_message"
    }
    
    init(_ type: Networking.Error) {
        self.statusCode = -1
        self.developerMessage = type.debugDescription
    }
}
