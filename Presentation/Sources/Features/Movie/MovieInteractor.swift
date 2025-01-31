//
//  MovieInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct MovieInteractor: Sendable {
    @Dependency(\.useCases.movie) private var movieUseCases
    
    func fetchMovieDetails(for movieId: Int) async -> Result<MovieDetails, TmdbError> {
        await movieUseCases.fetchDetails(movieId)
    }
    
    func toggleWatchlist(for movie: Movie) async {
        await movieUseCases.toggleWatchlist(movie)
    }
}

extension MovieInteractor: DependencyKey {
    static let liveValue = MovieInteractor()
    static let testValue = MovieInteractor()
}
