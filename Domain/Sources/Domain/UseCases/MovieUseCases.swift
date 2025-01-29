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
    public var fetchDetails: @Sendable (_ movieId: Int) async -> Result<MovieDetails, TmdbError>
}

extension MovieUseCases: DependencyKey {
    public static let liveValue = MovieUseCases(
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
