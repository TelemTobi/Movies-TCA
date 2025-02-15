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
        case genres = "genre_ids"
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
        return .init(string: Config.TmdbApi.photoBaseUrl + "/w780/" + posterPath)
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
            .localized(.genres): genres?.compactMap { $0.description }.joined(separator: ", "),
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
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        self.imdbId = try container.decodeIfPresent(String.self, forKey: .imdbId)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decodeIfPresent(Float.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        self.releaseDate = try? container.decodeIfPresent(Date.self, forKey: .releaseDate)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.voteAverage = try container.decodeIfPresent(Float.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    }
}
