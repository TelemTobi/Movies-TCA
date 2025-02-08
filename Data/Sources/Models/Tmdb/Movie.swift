//
//  Movie.swift
//  Data
//
//  Created by Telem Tobi on 12/11/2023.
//

import Foundation
import SwiftUI
import Core

public struct Movie: Codable, Equatable, Identifiable, Sendable {
    
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
        guard let voteAverage else { return .localized(.notAvailable) }
        return (voteAverage / 10).asPercentage
    }
    
    public var voteCountFormatted: String {
        guard let voteCount else { return .localized(.notAvailable) }
        return .localized(.numberOfVotes(voteCount.abbreviation))
    }
    
    public var posterUrl: URL? {
        guard let posterPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/original/" + posterPath)
    }
    
    public var posterThumbnailUrl: URL? {
        guard let posterPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w300/" + posterPath)
    }
    
    public var backdropUrl: URL? {
        guard let backdropPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w780/" + backdropPath)
    }
    
    public var backdropThumbnailUrl: URL? {
        guard let backdropPath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w400/" + backdropPath)
    }
    
    public var infoDictionary: [String: String] {
        [
            .localized(.releaseDate): releaseDate?.description(withFormat: .dMMMyyyy),
            .localized(.runtime): runtime?.durationInHoursAndMinutesLongFormat,
            .localized(.genres): genres?.compactMap { $0.name }.joined(separator: ", "),
            .localized(.status): status,
            .localized(.budget): budget?.currencyFormatted(),
            .localized(.revenue): revenue?.currencyFormatted(),
            .localized(.originalTitle): originalTitle,
            .localized(.country): productionCountries?.first?.name
        ].compactMapValues { $0 }
    }
    
    public init(id: Int) {
        self.id = id
    }
}
