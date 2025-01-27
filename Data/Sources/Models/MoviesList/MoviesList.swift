//
//  MoviesList.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 02/12/2023.
//

import Foundation

public struct MoviesList: Decodable, Equatable {
    
    public let results: [Movie]?
    public let page: Int?
    public let totalPages: Int?
    public let totalResults: Int?
    
    public enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
