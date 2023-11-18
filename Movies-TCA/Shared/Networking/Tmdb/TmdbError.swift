//
//  ApiError.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation

struct TmdbError: Errorable {
    
    let statusCode: Int?
    let developerMessage: String?
    
    var debugDescription: String {
        developerMessage ?? PredefinedError.unkownError.debugDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case developerMessage = "status_message"
    }
    
    init(_ errorType: PredefinedError) {
        statusCode = -1
        developerMessage = errorType.debugDescription
    }
}
