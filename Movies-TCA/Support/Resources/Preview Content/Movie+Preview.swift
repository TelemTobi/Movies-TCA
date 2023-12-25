//
//  Movie+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation

extension Movie {
    
    static var mock: Movie {
        let movie = try? MoviesList.self
            .resolve(Mock.nowPlayingMovies.dataEncoded)
            .parse(type: MoviesList.self, using: .tmdbDateDecodingStrategy)
            .results?.randomElement()
        
        guard let movie else {
            fatalError("Movies mock decoding error")
        }
        
        return movie
    }
}
