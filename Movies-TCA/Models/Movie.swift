//
//  Movie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation
import SwiftUI

struct Movie: Decodable, Equatable, Identifiable {
    
    let id: Int
    var adult: Bool?
    var backdropPath: String?
    var budget: Int?
    var genres: [Genre]?
    var homepage: String?
    var imdbId: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Float?
    var posterPath: String?
    var productionCountries: [ProductionCountry]?
    var releaseDate: Date?
    var revenue: Int?
    var runtime: Int?
    var status: String?
    var tagline: String?
    var title: String?
    var video: Bool?
    var voteAverage: Float?
    var voteCount: Int?
    
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case budget
        case genres
        case homepage
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
    
    var voteCountFormatted: LocalizedStringKey {
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
            "RELEASE DATE": releaseDate?.description(withFormat: .dMMMyyyy),
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
