//
//  MoviesList+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation
import Models

extension MoviesList {
    
    static var mock: MoviesList {
        let moviesList = try? Mock.nowPlayingMovies.dataEncoded
            .parse(type: MoviesList.self, using: .tmdbDateDecodingStrategy)
        
        guard let moviesList else {
            fatalError("Movies mock decoding error")
        }
        
        return moviesList
    }
}
