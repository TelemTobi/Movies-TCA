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
    @Dependency(\.useCases.genres) private var genresUseCases
    @Dependency(\.useCases.movies) private var moviesUseCases
    @Dependency(\.useCases.movie) private var movieUseCases
    
    var genres: [Genre] {
        get async { await genresUseCases.get() }
    }
    
    func discoverByGenre(_ genre: Genre) async -> Result<MovieList, TmdbError> {
        await moviesUseCases.discoverByGenre(genre)
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
