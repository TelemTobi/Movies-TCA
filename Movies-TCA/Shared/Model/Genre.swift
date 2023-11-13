//
//  Genre.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 13/11/2023.
//

import Foundation

struct GenresResponse: Decodable {
    let genres: [Genre]?
}

struct Genre: Decodable, Equatable {
    
    let id: Int?
    let name: String?
}
