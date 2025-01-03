//
//  MovieDetailsJsonMapper.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/12/2023.
//

import Foundation
import Flux

protocol MovieDetailsJsonMapper: JsonMapper {}

extension MovieDetailsJsonMapper {
    
    static func map(_ data: Data) throws -> Data {
        guard var jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return data }
        
        jsonDictionary["movie"] = jsonDictionary
        jsonDictionary["relatedMovies"] = jsonDictionary["recommendations"] ?? jsonDictionary["similar"]
        return try JSONSerialization.data(withJSONObject: jsonDictionary)
    }
}
