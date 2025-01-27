//
//  Genres+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/12/2023.
//

import Foundation
import Networking
import Models

extension GenresResponse {
    
    static var mock: GenresResponse {
        let response = try? Mock.listGenres.dataEncoded
            .parse(type: GenresResponse.self)
        
        guard let response else {
            fatalError("Movies mock decoding error")
        }
        
        return response
    }
}

extension Genre {
    
    static var mock: Genre {
        let genre = GenresResponse.mock.genres?.randomElement()
        
        guard let genre else {
            fatalError("Movies mock decoding error")
        }
        
        return genre
    }
}
