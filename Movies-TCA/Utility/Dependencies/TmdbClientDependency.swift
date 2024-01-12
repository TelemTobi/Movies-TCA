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

    init(client: TmdbClient) {
        self.fetchGenres = client.fetchGenres
        self.fetchMovies = client.fetchMovies
        self.searchMovies = client.searchMovies
        self.discoverMovies = client.discoverMovies
        self.movieDetails = client.movieDetails
    }
}

extension TmdbClientDependency: DependencyKey {
    
    static var liveValue: TmdbClientDependency {
        TmdbClientDependency(client: .live)
    }
    
    static var testValue: TmdbClientDependency {
        TmdbClientDependency(client: .test)
    }
    
    static var previewValue: TmdbClientDependency {
        TmdbClientDependency(client: .test)
    }
}

extension DependencyValues {
    
    var tmdbClient: TmdbClientDependency {
        get { self[TmdbClientDependency.self] }
        set { self[TmdbClientDependency.self] = newValue }
    }
}
