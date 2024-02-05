//
//  RootFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 14/11/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct RootFeature {
    
    @ObservableState
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
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .send(.loadGenres)
                
            case .loadGenres:
                return .run { send in
                    let genresResult = await tmdbClient.fetchGenres()
                    await send(.genresResponse(genresResult))
                }
                
            case let .genresResponse(.success(response)):
                state.isLoading = false
                
                if let genres = response.genres, genres.isNotEmpty {
                    return .send(.home(.setGenres(IdentifiedArray(uniqueElements: genres))))
                } else {
                    return .send(.genresResponse(.unknownError))
                }
                
            case let .genresResponse(.failure(error)):
                state.isLoading = false
                
                customDump(error) // TODO: Handle error
                return .none
                
                
            case .home:
                return .none
            }
        }
    }
}

