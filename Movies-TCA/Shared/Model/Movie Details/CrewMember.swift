//
//  CrewMember.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

struct CrewMember: Decodable, Equatable {
    
    let id: Int?
    let name: String?
    let profilePath: String?
    let isAdult: Bool?
    let department: String?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, department, job
        case profilePath = "profile_path"
        case isAdult = "adult"
    }
}
