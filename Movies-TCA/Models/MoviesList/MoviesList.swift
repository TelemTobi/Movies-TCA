//
//  MoviesList.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 02/12/2023.
//

import Foundation

struct MoviesList: Decodable, JsonResolver, Equatable {
    
    let results: [Movie]?
    let page: Int?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
