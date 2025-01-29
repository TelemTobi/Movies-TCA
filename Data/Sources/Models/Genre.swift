//
//  Genre.swift
//  Models
//
//  Created by Telem Tobi on 13/11/2023.
//

import Foundation

public struct GenresResponse: Decodable, Equatable, Sendable {
    public let genres: [Genre]?
}

public struct Genre: Codable, Equatable, Identifiable, Hashable, Sendable {
    
    public let id: Int
    public let name: String?
}
