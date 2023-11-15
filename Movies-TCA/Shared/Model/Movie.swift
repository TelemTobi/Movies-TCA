//
//  Movie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation

struct Movie: Decodable, Equatable {
    
    let id: Int?
    let title: String?
    let overview: String?
    let language: String?
    let popularity: Float?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: Date?
    let voteAverage: Float?
    let voteCount: Int?
    let hasTrailer: Bool?
    let isAdult: Bool?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case language = "original_language"
        case popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case hasTrailer = "video"
        case isAdult = "adult"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres = "genre_ids"
        
    }
}
