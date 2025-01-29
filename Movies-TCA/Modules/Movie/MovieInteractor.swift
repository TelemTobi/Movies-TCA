//
//  MovieInteractor.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct MovieInteractor: Sendable {
    @Dependency(\.useCases.movie) private var movie
    
    func fetchMovieDetails(for movieId: Int) async -> Result<MovieDetails, TmdbError> {
        await movie.fetchDetails(movieId)
    }
}

extension MovieInteractor: DependencyKey {
    static let liveValue = MovieInteractor()
    static let testValue = MovieInteractor()
}
