//
//  ProductionCountry.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/12/2023.
//

import Foundation

struct ProductionCountry: Decodable, Equatable {
    
    let iso31661: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
