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
    public var fetchList: @Sendable (MovieListType) async -> Result<MovieList, TmdbError>
    public var search: @Sendable (_ query: String) async -> Result<MovieList, TmdbError>
    public var discoverByGenre: @Sendable (Genre) async -> Result<MovieList, TmdbError>
    public var fetchLists: @Sendable ([MovieListType]) async -> [MovieListType: Result<MovieList, TmdbError>]
}

extension MoviesUseCases: DependencyKey {
    public static let liveValue = MoviesUseCases(
        favorites: {
            @Dependency(\.appData) var appData
            return await appData.$watchlist
        },
        fetchList: { listType in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.fetchMovies(ofType: listType)
        },
        search: { query in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.searchMovies(query: query)
        },
        discoverByGenre: { genre in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.discoverByGenre(genre)
        },
        fetchLists: { listTypes in
            await withTaskGroup(of: (MovieListType, Result<MovieList, TmdbError>).self) { group in
                for listType in listTypes {
                    group.addTask {
                        @Dependency(\.tmdbApiClient) var tmdbApiClient
                        
                        let result = await tmdbApiClient.fetchMovies(ofType: listType)
                        return (listType, result)
                    }
                }
                
                return await group.reduce(into: [:]) { partialResult, movieListResponse in
                    partialResult[movieListResponse.0] = movieListResponse.1
                }
            }
        }
    )
    
    public static let testValue: MoviesUseCases = .liveValue
}

extension DependencyValues {
    var moviesUseCases: MoviesUseCases {
        get { self[MoviesUseCases.self]}
    }
}
