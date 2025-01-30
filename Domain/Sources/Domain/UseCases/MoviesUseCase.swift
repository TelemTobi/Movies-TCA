//
//  MoviesUseCase.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import IdentifiedCollections
import Sharing
import Models
import TmdbApi

public struct MoviesUseCases: Sendable {
    public var favorites: @Sendable () async -> Shared<IdentifiedArrayOf<Movie>>
    public var fetchList: @Sendable (MoviesListType) async -> Result<MovieList, TmdbError>
    public var search: @Sendable (_ query: String) async -> Result<MovieList, TmdbError>
    public var discoverByGenre: @Sendable (_ genreId: Int) async -> Result<MovieList, TmdbError>
}

extension MoviesUseCases: DependencyKey {
    public static let liveValue = MoviesUseCases(
        favorites: {
            @Dependency(\.appData) var appData
            return appData.$watchlist
        },
        fetchList: { listType in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.fetchMovies(ofType: listType)
        },
        search: { query in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.searchMovies(query: query)
        },
        discoverByGenre: { genreId in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.discoverMovies(by: genreId)
        }
    )
}

extension DependencyValues {
    var moviesUseCases: MoviesUseCases {
        get { self[MoviesUseCases.self]}
    }
}
