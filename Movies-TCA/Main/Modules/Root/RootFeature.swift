//
//  RootFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import ComposableArchitecture

struct RootFeature: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        var home = HomeFeature.State()
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case loadGenres
        case genresResponse(Result<GenresResponse, TmdbError>)
        
        case home(HomeFeature.Action)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .onFirstAppear:
                    return .send(.loadGenres)
                    
                case .loadGenres:
                    return .run { send in
                        await send(.genresResponse(tmdbClient.fetchGenres()))
                    }
                    
                case let .genresResponse(.success(response)):
                    state.isLoading = false

                    if let genres = response.genres, genres.isNotEmpty {
                        state.home.movieGenres = genres
                    } else {
                        return .send(.genresResponse(.unknownError))
                    }
                    return .none
                    
                case let .genresResponse(.failure(error)):
                    customDump(error) // TODO: Handle error
                    return .none
                    
                case .home:
                    return .none
            }
        }
    }
}

