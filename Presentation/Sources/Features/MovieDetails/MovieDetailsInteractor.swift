//
//  MovieDetailsInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct MovieDetailsInteractor: Sendable {
    @Dependency(\.useCases.movie) private var movieUseCases
    
    func fetchMovieDetails(for movieId: Int) async -> Result<DetailedMovie, TmdbError> {
        await movieUseCases.fetchDetails(movieId)
    }
    
    func toggleWatchlist(for movie: Movie) async {
        await movieUseCases.toggleWatchlist(movie)
    }
}

extension MovieDetailsInteractor: DependencyKey {
    static let liveValue = MovieDetailsInteractor()
    static let testValue = MovieDetailsInteractor()
}
