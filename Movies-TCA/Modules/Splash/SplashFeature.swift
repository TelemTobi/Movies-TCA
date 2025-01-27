//
//  SplashFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/03/2024.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
struct SplashFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared(.genres) var genres = []
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onAppear
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case splashCompleted
        }
        
        case view(View)
        case navigation(Navigation)
        case loadGenres
        case genresResponse(Result<GenresResponse, TmdbError>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .loadGenres:
                return .run { send in
                    let genresResult = await tmdbClient.fetchGenres()
                    await send(.genresResponse(genresResult))
                }
                
            case let .genresResponse(.success(result)):
                guard let genres = result.genres, genres.isNotEmpty else {
                    return .send(.genresResponse(.failure(.unknownError)))
                }
                
                state.$genres.withLock { $0 = genres }
                return .send(.navigation(.splashCompleted))
                
            case let .genresResponse(.failure(error)):
                customDump(error) // TODO: Handle error
                return .none
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.loadGenres)
        }
    }
}
