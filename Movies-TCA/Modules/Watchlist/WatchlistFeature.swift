//
//  WatchlistFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WatchlistFeature {
    
    @ObservableState
    struct State: Equatable {
        var likedMovies: IdentifiedArrayOf<Movie> = []
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case setLikedMovies([LikedMovie])
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onMovieDislike(Movie)
        }
        
        enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
        }
        
        case view(View)
        case navigation(Navigation)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmDislike(Movie)
        }
    }
    
    @Dependency(\.database) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .alert(.presented(.confirmDislike(movie))):
                return .send(.view(.onMovieLike(movie)))
                
            case .navigation, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case let .setLikedMovies(likedMovies):
            state.likedMovies = .init(uniqueElements: likedMovies.map { $0.toMovie })
            return .none
            
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case .onPreferencesTap:
            return .send(.navigation(.presentPreferences))
            
        case let .onMovieLike(movie):
            try? database.setMovieLike(movie)
            return .none
            
        case let .onMovieDislike(movie):
            state.alert = .dislikeConfirmation(for: movie)
            return .none
        }
    }
}
