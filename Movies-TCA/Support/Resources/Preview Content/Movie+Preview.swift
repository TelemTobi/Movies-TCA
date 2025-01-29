//
//  Movie+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation
import Models
import TmdbApi

extension Movie {
    
    static var mock: Movie {
        let movie = try? Mock.nowPlayingMovies.dataEncoded
            .parse(type: MovieList.self, using: .tmdbDateDecodingStrategy)
            .movies?.randomElement()
        
        guard let movie else {
            fatalError("Movies mock decoding error")
        }
        
        return movie
    }
}
