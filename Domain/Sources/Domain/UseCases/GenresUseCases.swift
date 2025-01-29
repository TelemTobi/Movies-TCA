//
//  Genres.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import TmdbApi

struct GenresUsecases {
    public var get: @Sendable () -> [Genre]
    public var fetch: @Sendable () async -> Result<GenresResponse, TmdbError>
}

extension GenresUsecases: DependencyKey {
    public static let liveValue = GenresUsecases(
        get: {
            []
        },
        fetch: {
            @Dependency(\.tmdbApi) var tmdbApi
            let result = await tmdbApi.fetchGenres()
            
            if let genres = try? result.get().genres {
                @Dependency(\.appData) var appData
                appData.setGenres(genres)
            }
            
            return result
        }
    )
}
