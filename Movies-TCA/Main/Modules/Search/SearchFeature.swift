//
//  SearchFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture

struct SearchFeature: Reducer {
    
    struct State: Equatable {
        var isLoading = true
        var genres: IdentifiedArrayOf<Genre> = []
        
        @BindingState var searchInput: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        case onFirstAppear
        case loadGenres
        case genresResponse(Result<GenresResponse, TmdbError>)

        case binding(BindingAction<State>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
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
                    state.genres = IdentifiedArray(uniqueElements: genres)
                } else {
                    return .send(.genresResponse(.unknownError))
                }
                return .none
                
            case let .genresResponse(.failure(error)):
                state.isLoading = false
                
                customDump(error) // TODO: Handle error
                return .none
                
            case .binding(_):
                return .none
            }
        }
    }
}
