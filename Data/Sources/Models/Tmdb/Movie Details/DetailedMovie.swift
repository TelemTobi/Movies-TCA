//
//  DetailedMovie.swift
//  Data
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation
import Networking

public struct DetailedMovie: Decodable, Equatable, Sendable, JsonMapper {
    public var movie: Movie
    public var credits: Credits?
    public var relatedMovies: MovieList?
    
    public init(movie: Movie, credits: Credits? = nil, relatedMovies: MovieList? = nil) {
        self.movie = movie
        self.credits = credits
        self.relatedMovies = relatedMovies
    }
}

public extension DetailedMovie {
    static func map(_ data: Data) throws -> Data {
        guard var jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return data }
        
        if let genres = jsonDictionary["genres"] as? [[String: Any]] {
            jsonDictionary["genre_ids"] = genres.compactMap { $0["id"] }
        }
        
        jsonDictionary["movie"] = jsonDictionary
        jsonDictionary["relatedMovies"] = jsonDictionary["recommendations"] ?? jsonDictionary["similar"]
        
        return try JSONSerialization.data(withJSONObject: jsonDictionary)
    }
}
