//
//  MovieDetails+Preview.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 25/12/2023.
//

import Foundation
import Flux

extension MovieDetails {
    
    static var mock: MovieDetails {
        let movie = try? MovieDetails.self
            .map(Mock.movieDetails.dataEncoded)
            .parse(type: MovieDetails.self, using: .tmdbDateDecodingStrategy)
        
        guard let movie else {
            fatalError("MovieDetails mock decoding error")
        }
        
        return movie
    }
}
