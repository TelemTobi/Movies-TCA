//
//  HTTPTask.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 18/11/2023.
//

import Foundation

enum HTTPTask {
    
    /// A request with no additional data.
    case requestPlain

    /// A request set with query parameters.
    case requestParameters([String: Any])
    
    /// A request body set with `Encodable` type
    case requestEncodable(Encodable)

    /// A request body set with `Encodable` type, combined with query parameters.
    case requestCompositeEncodable(Encodable, queryParameters: [String: Any])
}
