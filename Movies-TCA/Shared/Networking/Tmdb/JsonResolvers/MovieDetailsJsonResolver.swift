//
//  MovieDetailsJsonResolver.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/12/2023.
//

import Foundation

protocol MovieDetailsJsonResolver: JsonResolver {}

extension MovieDetailsJsonResolver {
    
    static func resolve(_ data: Data) throws -> Data {
        guard let movie = try? data.parse(type: Movie.self, using: .tmdbDateDecodingStrategy, .useDefaultKeys),
              var jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else { return data }
        
        jsonDictionary["Movie"] = movie
        return try JSONSerialization.data(withJSONObject: jsonDictionary)
    }
}
