//
//  SearchInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct SearchInteractor: Sendable {
    @Dependency(\.useCases.movies) private var moviesUseCases
    @Dependency(\.useCases.movie) private var movieUseCases
    
    func discoverMovies(by genreId: Int) async -> Result<MovieList, TmdbError> {
        await moviesUseCases.discoverByGenre(genreId)
    }
    
    func searchMovies(using query: String) async -> Result<MovieList, TmdbError> {
        await moviesUseCases.search(query)
    }
    
    func toggleWatchlist(for movie: Movie) async {
        await movieUseCases.toggleWatchlist(movie)
    }
}

extension SearchInteractor: DependencyKey {
    static let liveValue = SearchInteractor()
    static let testValue = SearchInteractor()
}
