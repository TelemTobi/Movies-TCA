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
    public var toggleFavorite: @Sendable (_ movie: Movie) async -> Void
    public var fetchDetails: @Sendable (_ movieId: Int) async -> Result<MovieDetails, TmdbError>
}

extension MovieUseCases: DependencyKey {
    public static let liveValue = MovieUseCases(
        toggleFavorite: { movie in
            @Dependency(\.appData) var appData
            
            if appData.favoriteMovies.contains(movie) {
                let _ = appData.$favoriteMovies.withLock { $0.remove(movie) }
            } else {
                let _ = appData.$favoriteMovies.withLock { $0.append(movie) }
            }
        },
        fetchDetails: { movieId in
            @Dependency(\.tmdbApiClient) var tmdbApiClient
            return await tmdbApiClient.movieDetails(for: movieId)
        }
    )
}

extension DependencyValues {
    var movieUseCases: MovieUseCases {
        get { self[MovieUseCases.self]}
    }
}
