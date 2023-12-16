//
//  Movie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation

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
    let runtime: Int?
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
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case hasTrailer = "video"
        case isAdult = "adult"
        case runtime = "runtime"
        case genres = "genres"
    }
    
    var voteAverageFormatted: String {
        guard let voteAverage else { return .notAvailable }
        return (voteAverage / 10).asPercentage
    }
    
    var voteCountFormatted: String {
        guard let voteCount else { return .notAvailable }
        return "\(voteCount.abbreviation) votes"
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
