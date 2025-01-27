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
        @Shared(.likedMovies) var likedMovies: IdentifiedArrayOf<Movie> = []
        @Presents var alert: AlertState<Action.Alert>?
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieDislike(Movie)
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
        }
        
        case view(View)
        case navigation(Navigation)
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        enum Alert: Equatable {
            case confirmDislike(Movie)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .alert(.presented(.confirmDislike(movie))):
                state.$likedMovies.withLock { $0.remove(movie) }
                return .none
                
            case .navigation, .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case .onPreferencesTap:
            return .send(.navigation(.presentPreferences))
            
        case let .onMovieDislike(movie):
            state.alert = .dislikeConfirmation(for: movie)
            return .none
        }
    }
}
