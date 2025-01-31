//
//  Data+Extension.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 19/11/2023.
//

import Foundation

public extension Data {
    
    func parse<T: Decodable>(type: T.Type, using dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = .iso8601, _ keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
        
        if let dateDecodingStrategy = dateDecodingStrategy {
            jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
        }
        
        return try jsonDecoder.decode(type, from: self)
    }
}
