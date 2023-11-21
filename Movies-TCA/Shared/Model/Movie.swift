//
//  Movie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation

struct MoviesList: Decodable, JsonResolver, Equatable {
    
    let results: [Movie]?
    let page: Int?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    enum ListType: String {
        case nowPlaying
        case popular
        case topRated
        case upcoming
    }
}

struct Movie: Decodable, Equatable, Identifiable {
    
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
    let genreIds: [Int]?
    
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
        case genreIds = "genre_ids"
        
    }
}
