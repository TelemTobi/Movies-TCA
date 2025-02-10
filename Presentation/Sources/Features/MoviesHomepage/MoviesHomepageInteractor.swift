//
//  MoviesHomepageInteractor.swift
//  Presentation
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import Domain

struct MoviesHomepageInteractor: Sendable {
    @Dependency(\.useCases.movies) private var moviesUseCases
    @Dependency(\.useCases.movie) private var movieUseCases
    
    func fetchMovieLists(ofTypes types: MovieListType...) async -> [MovieListType: Result<MovieList, TmdbError>] {
        await moviesUseCases.fetchLists(types)
    }
    
    func fetchMovieList(ofType type: MovieListType) async -> Result<MovieList, TmdbError> {
        await moviesUseCases.fetchList(type)
    }
    
    func toggleWatchlist(for movie: Movie) async {
        await movieUseCases.toggleWatchlist(movie)
    }
}

extension MoviesHomepageInteractor: DependencyKey {
    static let liveValue = MoviesHomepageInteractor()
    static let testValue = MoviesHomepageInteractor()
}
