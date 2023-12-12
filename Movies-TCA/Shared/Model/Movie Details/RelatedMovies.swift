//
//  RelatedMovies.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

struct RelatedMovies: Decodable, Equatable {
    
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
