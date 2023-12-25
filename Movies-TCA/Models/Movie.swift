//
//  Movie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation

struct Movie: Decodable, Equatable, Identifiable {
    
    let genreIds: [Int]?
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let productionCountries: [ProductionCountry]?
    let releaseDate: Date?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case genreIds = "genre_ids"
        case adult
        case backdropPath = "backdrop_path"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
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
    
    var infoDictionary: [String: String] {
        [
            "RELEASE DATE": releaseDate?.description(withFormat: .dMMMyyyy, locale: .english),
            "RUNTIME": runtime?.durationInHoursAndMinutesLongFormat,
            "GENRES": genres?.compactMap { $0.name }.joined(separator: ", "),
            "STATUS": status,
            "BUDGET": budget?.currencyFormatted(),
            "REVENUE": revenue?.currencyFormatted(),
            "ORIGINAL TITLE": originalTitle,
            "COUNTRY": productionCountries?.first?.name
        ].compactMapValues { $0 }
    }
}
