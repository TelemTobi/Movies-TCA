//
//  CrewMember.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation
import Core

public struct CrewMember: Person, Decodable, Equatable {
    
    public let id: Int?
    public let name: String?
    public let profilePath: String?
    public let isAdult: Bool?
    public let department: String?
    public let job: String?
    
    public enum CodingKeys: String, CodingKey {
        case id, name, department, job
        case profilePath = "profile_path"
        case isAdult = "adult"
    }
    
    public var imageUrl: URL? {
        guard let profilePath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/original/" + profilePath)
    }
}
