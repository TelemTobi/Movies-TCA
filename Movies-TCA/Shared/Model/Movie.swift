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
    
    enum ListType: String, CaseIterable {
        case nowPlaying, popular, topRated, upcoming
        
        var title: String {
            return switch self {
                case .nowPlaying: "Now Playing"
                case .popular: "Popular"
                case .topRated: "Top Rated"
                case .upcoming: "Upcoming"
            }
        }
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
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case hasTrailer = "video"
        case isAdult = "adult"
        case genreIds = "genre_ids"
    }
    
    var posterUrl: URL? {
        guard let posterPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/original/" + posterPath)
    }
    
    var thumbnailUrl: URL? {
        guard let posterPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w500/" + posterPath)
    }
    
    var backdropUrl: URL? {
        guard let backdropPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w780/" + backdropPath)
    }
}

extension Movie {
    
    static var mock: Movie {
        let movie = try? MoviesList.self
            .resolve(Mock.nowPlayingMovies.dataEncoded)
            .parse(type: MoviesList.self, using: .tmdbDateDecodingStrategy)
            .results?.randomElement()
        
        guard let movie else {
            fatalError("Movies mock decoding error")
        }
        
        return movie
    }
}
