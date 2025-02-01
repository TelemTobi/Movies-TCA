//
//  MovieUseCases.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import TmdbApi

public struct MovieUseCases: Sendable {
    public var toggleWatchlist: @Sendable (_ movie: Movie) async -> Void
    public var fetchDetails: @Sendable (_ movieId: Int) async -> Result<MovieDetails, TmdbError>
}

extension MovieUseCases: DependencyKey {
    public static let liveValue = MovieUseCases(
        toggleWatchlist: { movie in
            @Dependency(\.appData) var appData
            
            if appData.watchlist.contains(movie) {
                let _ = appData.$watchlist.withLock { $0.remove(movie) }
            } else {
                let _ = appData.$watchlist.withLock { $0.append(movie) }
            }
        },
        fetchDetails: { movieId in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.movieDetails(for: movieId)
        }
    )
    
    public static let testValue: MovieUseCases = .liveValue
}

extension DependencyValues {
    var movieUseCases: MovieUseCases {
        get { self[MovieUseCases.self]}
    }
}
