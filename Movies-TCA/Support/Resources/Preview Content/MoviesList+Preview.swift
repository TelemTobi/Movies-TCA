//
//  MoviesList+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation
import Models
import TmdbApi

extension MovieList {
    
    static var mock: MovieList {
        let moviesList = try? Mock.nowPlayingMovies.dataEncoded
            .parse(type: MovieList.self, using: .tmdbDateDecodingStrategy)
        
        guard let moviesList else {
            fatalError("Movies mock decoding error")
        }
        
        return moviesList
    }
}
