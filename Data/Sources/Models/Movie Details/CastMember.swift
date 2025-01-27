//
//  Actor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

public struct CastMember: Person, Decodable, Equatable, Identifiable {
    
    public let id: Int?
    public let name: String?
    public let profilePath: String?
    public let isAdult: Bool?
    public let department: String?
    public let character: String?
    
    public enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
        case isAdult = "adult"
        case department = "known_for_department"
    }
    
    public var imageUrl: URL? {
        guard let profilePath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/original/" + profilePath)
    }
}
