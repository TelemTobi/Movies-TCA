//
//  Movie.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation
import SwiftUI

public struct Movie: Codable, Equatable, Identifiable {
    
    public let id: Int
    public var adult: Bool?
    public var backdropPath: String?
    public var budget: Int?
    public var genres: [Genre]?
    public var homepage: String?
    public var imdbId: String?
    public var originalLanguage: String?
    public var originalTitle: String?
    public var overview: String?
    public var popularity: Float?
    public var posterPath: String?
    public var productionCountries: [ProductionCountry]?
    public var releaseDate: Date?
    public var revenue: Int?
    public var runtime: Int?
    public var status: String?
    public var tagline: String?
    public var title: String?
    public var video: Bool?
    public var voteAverage: Float?
    public var voteCount: Int?
    
    public enum CodingKeys: String, CodingKey {
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
    
    public var voteAverageFormatted: String {
        guard let voteAverage else { return .notAvailable }
        return (voteAverage / 10).asPercentage
    }
    
    public var voteCountFormatted: LocalizedStringKey {
        guard let voteCount else { return .notAvailable }
        return "\(voteCount.abbreviation) votes"
    }
    
    public var posterUrl: URL? {
        guard let posterPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/original/" + posterPath)
    }
    
    public var thumbnailUrl: URL? {
        guard let posterPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w500/" + posterPath)
    }
    
    public var backdropUrl: URL? {
        guard let backdropPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w780/" + backdropPath)
    }
    
    public var infoDictionary: [String: String] {
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
