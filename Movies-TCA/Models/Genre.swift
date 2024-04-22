//
//  Genre.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 13/11/2023.
//

import Foundation

struct GenresResponse: Decodable, JsonResolver, Equatable {
    let genres: [Genre]?
}

struct Genre: Codable, Equatable, Identifiable {
    
    let id: Int
    let name: String?
}
