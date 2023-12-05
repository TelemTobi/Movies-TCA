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
    var fetchMovies: @Sendable (MoviesList.ListType) async -> Result<MoviesList, TmdbError>
    var searchMovies: @Sendable (String) async -> Result<MoviesList, TmdbError>
    var discoverMovies: @Sendable (Int) async -> Result<MoviesList, TmdbError>
}

extension TmdbClientDependency: DependencyKey {
    
    static var liveValue: TmdbClientDependency {
        TmdbClientDependency(
            fetchGenres: TmdbClient.live.fetchGenres,
            fetchMovies: TmdbClient.live.fetchMovies,
            searchMovies: TmdbClient.live.searchMovies,
            discoverMovies: TmdbClient.live.discoverMovies
        )
    }
    
    static var testValue: TmdbClientDependency {
        TmdbClientDependency(
            fetchGenres: TmdbClient.test.fetchGenres,
            fetchMovies: TmdbClient.test.fetchMovies,
            searchMovies: TmdbClient.test.searchMovies,
            discoverMovies: TmdbClient.test.discoverMovies
        )
    }
    
    static var previewValue: TmdbClientDependency {
        TmdbClientDependency(
            fetchGenres: TmdbClient.test.fetchGenres,
            fetchMovies: TmdbClient.test.fetchMovies,
            searchMovies: TmdbClient.test.searchMovies,
            discoverMovies: TmdbClient.test.discoverMovies
        )
    }
}

extension DependencyValues {
    
    var tmdbClient: TmdbClientDependency {
        get { self[TmdbClientDependency.self] }
        set { self[TmdbClientDependency.self] = newValue }
    }
}
