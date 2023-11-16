//
//  RootFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import ComposableArchitecture

struct Root: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        var home = Home.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case loadGenres
        case genresLoaded([Genre])
        case home(Home.Action)
    }
    
    var fetchGenres: @Sendable () async throws -> [Genre]
    
    static let live = Self(
        fetchGenres: ApiClient.Tmdb.fetchGenres
    )
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onFirstAppear:
                    return .send(.loadGenres)
                    
                case .loadGenres:
                    return .run { send in
                        let genres = try await fetchGenres()
                        await send(.genresLoaded(genres))
                    }
                    
                case let .genresLoaded(genres):
                    state.home.movieGenres = genres
                    state.isLoading = false
                    return .none
                    
                case .home:
                    return .none
            }
        }
    }
}

