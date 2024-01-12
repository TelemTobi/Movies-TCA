//
//  TmdbClientDependency.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 21/11/2023.
//

import Foundation
import ComposableArchitecture

struct TmdbClientDependency {
    var fetchGenres: @Sendable () async -> Result<GenresResponse, TmdbError>
    var fetchMovies: @Sendable (MoviesListType) async -> Result<MoviesList, TmdbError>
    var searchMovies: @Sendable (String) async -> Result<MoviesList, TmdbError>
    var discoverMovies: @Sendable (Int) async -> Result<MoviesList, TmdbError>
    var movieDetails: @Sendable (Int) async -> Result<MovieDetails, TmdbError>

    init(tmdbClient: TmdbClient) {
        self.fetchGenres = tmdbClient.fetchGenres
        self.fetchMovies = tmdbClient.fetchMovies
        self.searchMovies = tmdbClient.searchMovies
        self.discoverMovies = tmdbClient.discoverMovies
        self.movieDetails = tmdbClient.movieDetails
    }
}

extension TmdbClientDependency: DependencyKey {
    
    static let liveValue = Self(tmdbClient: .live)
    static let testValue = Self(tmdbClient: .test)
    static let previewValue = Self(tmdbClient: .test)
}

extension DependencyValues {
    
    var tmdbClient: TmdbClientDependency {
        get { self[TmdbClientDependency.self] }
        set { self[TmdbClientDependency.self] = newValue }
    }
}
