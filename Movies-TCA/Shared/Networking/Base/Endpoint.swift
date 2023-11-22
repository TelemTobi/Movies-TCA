//
//  EndPoint.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/11/2023.
//

import Foundation

/// The protocol used to define the specifications necessary for a URLRequest..
protocol Endpoint {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }

    /// The type of HTTP task to be performed.
    var task: HTTPTask { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    /// Provides stub data for use in testing. Default is `nil`.
    var sampleData: Data? { get }
    
    /// Strategy for decoding keys. Default is `useDefaultKeys`.
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    
    /// Strategy for decoding dates. Default is `iso8601`.
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension Endpoint {
    
    var sampleData: Data? { nil }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { .useDefaultKeys }
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { .iso8601 }
}
