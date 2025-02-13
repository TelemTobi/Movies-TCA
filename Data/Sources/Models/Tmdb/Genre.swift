//
//  Genre.swift
//  Data
//
//  Created by Telem Tobi on 13/11/2023.
//

import Foundation
import Networking
import Core

public struct GenresResponse: Decodable, Equatable, Sendable, JsonMapper {
    public let genres: [Genre]?
    
    public static func map(_ data: Data) throws -> Data {
        guard var jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return data }
        
        if let genres = jsonDictionary["genres"] as? [[String: Any]] {
            jsonDictionary["genres"] = genres.compactMap { $0["id"] }
        }
        
        return try JSONSerialization.data(withJSONObject: jsonDictionary)
    }
}

public enum Genre: Int, Codable, Sendable {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scienceFiction = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37
    case unknown
    
    public var description: String {
        switch self {
        case .action: "Action"
        case .adventure: "Adventure"
        case .animation: "Animation"
        case .comedy: "Comedy"
        case .crime: "Crime"
        case .documentary: "Documentary"
        case .drama: "Drama"
        case .family: "Family"
        case .fantasy: "Fantasy"
        case .history: "History"
        case .horror: "Horror"
        case .music: "Music"
        case .mystery: "Mystery"
        case .romance: "Romance"
        case .scienceFiction: "Sci-Fi"
        case .tvMovie: "TV Movie"
        case .thriller: "Thriller"
        case .war: "War"
        case .western: "Western"
        case .unknown: .localized(.notAvailable)
        }
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        self = Genre(rawValue: rawValue) ?? .unknown
    }
}
