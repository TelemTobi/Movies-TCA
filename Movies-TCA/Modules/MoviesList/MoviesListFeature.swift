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
        
        @Shared(.likedMovies) fileprivate var likedMovies: IdentifiedArrayOf<Movie> = []
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onMovieTap(Movie)
            case onMovieLike(Movie, Bool)
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
            
        case let .onMovieLike(movie, isLiked):
            state.movies[id: movie.id]?.isLiked = isLiked
            
            if isLiked, let movie = state.movies[id: movie.id] {
                state.likedMovies.append(movie)
            } else {
                state.likedMovies.remove(movie)
            }
            
            return .none
        }
    }
}
