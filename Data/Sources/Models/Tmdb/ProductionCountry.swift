//
//  ProductionCountry.swift
//  Data
//
//  Created by Telem Tobi on 22/12/2023.
//

import Foundation

public struct ProductionCountry: Codable, Equatable, Sendable {
    
    public let iso31661: String
    public let name: String

    public enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
