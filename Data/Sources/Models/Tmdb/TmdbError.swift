//
//  TmdbError.swift
//  Data
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import Networking

public struct TmdbError: DecodableError, Equatable {
    
    public let statusCode: Int?
    public let developerMessage: String?
    
    public enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case developerMessage = "status_message"
    }
    
    public init(_ type: Networking.Error) {
        self.statusCode = -1
        self.developerMessage = type.debugDescription
    }
}
