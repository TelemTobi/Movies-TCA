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
}

extension TmdbClientDependency: DependencyKey {
    
    static var liveValue: TmdbClientDependency {
        TmdbClientDependency(
            fetchGenres: TmdbClient.live.fetchGenres
        )
    }
}

extension DependencyValues {
    
    var tmdbClient: TmdbClientDependency {
        get { self[TmdbClientDependency.self] }
        set { self[TmdbClientDependency.self] = newValue }
    }
}
