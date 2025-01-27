//
//  MovieDetails.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 12/12/2023.
//

import Foundation

public struct MovieDetails: Decodable, Equatable, MovieDetailsJsonMapper {
    public var movie: Movie
    public var credits: Credits?
    public var relatedMovies: MoviesList?
}
