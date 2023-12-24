//
//  Actor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

struct CastMember: Person, Decodable, Equatable, Identifiable {
    
    let id: Int?
    let name: String?
    let profilePath: String?
    let isAdult: Bool?
    let department: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
        case isAdult = "adult"
        case department = "known_for_department"
    }
    
    var imageUrl: URL? {
        guard let profilePath else { return nil }
        return .init(string: Config.TmdbApi.photoBaseUrl + "/original/" + profilePath)
    }
}

extension CastMember {
    
    static var mock: CastMember {
        guard let castMember = MovieDetails.mock.credits?.cast?.randomElement() else {
            fatalError("CastMember mock decoding error")
        }
        return castMember
    }
}
