//
//  GenresUseCases.swift
//  Domain
//
//  Created by Telem Tobi on 29/01/2025.
//

import Foundation
import Dependencies
import Models
import TmdbApi

public struct GenresUseCases: Sendable {
    public var get: @Sendable () async -> [Genre]
    public var fetch: @Sendable () async -> Result<GenresResponse, TmdbError>
}

extension GenresUseCases: DependencyKey {
    public static let liveValue = GenresUseCases(
        get: {
            @Dependency(\.appData) var appData
            return await appData.genres
        },
        fetch: {
            @Dependency(\.tmdbApiClient) var tmdbApi
            let result = await tmdbApi.fetchGenres()
            
            if let genres = try? result.get().genres {
                @Dependency(\.appData) var appData
                await appData.setGenres(genres)
            }
            
            return result
        }
    )
    
    public static let testValue: GenresUseCases = .liveValue
}

extension DependencyValues {
    var genresUseCases: GenresUseCases {
        get { self[GenresUseCases.self]}
    }
}
