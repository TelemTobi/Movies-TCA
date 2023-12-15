//
//  MovieDetails.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

struct MovieDetails: Decodable, Equatable, MovieDetailsJsonResolver {
    let movie: Movie?
    var credits: Credits?
    var relatedMovies: MoviesList?
}
