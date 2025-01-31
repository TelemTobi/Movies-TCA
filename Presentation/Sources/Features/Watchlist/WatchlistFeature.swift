//
//  WatchlistFeature.swift
//  Presentation
//
//  Created by Telem Tobi on 06/12/2023.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
struct WatchlistFeature {
    
    @ObservableState
    struct State: Equatable {
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
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
    
    @Dependency(\.interactor) private var interactor
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .alert(.presented(.confirmDislike(movie))):
                return .run { _ in
                    await interactor.toggleWatchlist(for: movie)
                }
                
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

extension DependencyValues {
    fileprivate var interactor: WatchlistInteractor {
        get { self[WatchlistInteractor.self] }
    }
}
