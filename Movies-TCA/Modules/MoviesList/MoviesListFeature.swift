//
//  MoviesListFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoviesListFeature {
    
    @ObservableState
    struct State: Equatable {
        var listType: MoviesListType?
        var movies: IdentifiedArrayOf<Movie> = []
        
        @Shared(.likedMovies)
        var likedMovies: IdentifiedArrayOf<Movie> = []
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onMovieTap(Movie)
            case onMovieLike(Movie)
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case presentMovie(Movie)
        }
        
        case view(View)
        case navigation(Navigation)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                state.likedMovies.append(<#T##item: Movie##Movie#>)
                return reduceViewAction(&state, viewAction)
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case let .onMovieLike(movie):
            if state.likedMovies.contains(movie) {
                state.likedMovies.remove(movie)
            } else {
                state.likedMovies.append(movie)
            }
            return .none
        }
    }
}
