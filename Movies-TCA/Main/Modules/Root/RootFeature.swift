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
        case genresLoadingSucceeded([Genre])
        case genresLoadingFailed(ApiError?)
        
        case home(Home.Action)
    }
    
    var fetchGenres: @Sendable () async -> (GenresResponse?, ApiError?)
    
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
                        let (response, error) = await fetchGenres()
                        
                        if let genres = response?.genres, genres.isNotEmpty {
                            await send(.genresLoadingSucceeded(genres))
                        } else {
                            await send(.genresLoadingFailed(error))
                        }
                    }
                    
                case let .genresLoadingSucceeded(genres):
                    customDump(genres)
                    state.home.movieGenres = genres
                    state.isLoading = false
                    return .none
                    
                case let .genresLoadingFailed(error):
                    customDump(error) // TODO: Handle error somehow
                    return .none
                    
                case .home:
                    return .none
            }
        }
    }
}

