//
//  MovieList.swift
//  Data
//
//  Created by Telem Tobi on 02/12/2023.
//

import Foundation

public struct MovieList: Decodable, Equatable, Sendable {
    
    public let movies: [Movie]?
    public let page: Int?
    public let totalPages: Int?
    public let totalResults: Int?
    
    public enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    public init(movies: [Movie]?, page: Int? = nil, totalPages: Int? = nil, totalResults: Int? = nil) {
        self.movies = movies
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
