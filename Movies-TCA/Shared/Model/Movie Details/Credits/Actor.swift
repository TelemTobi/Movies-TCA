//
//  Actor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

struct Actor: Decodable, Equatable, Identifiable {
    
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
}
