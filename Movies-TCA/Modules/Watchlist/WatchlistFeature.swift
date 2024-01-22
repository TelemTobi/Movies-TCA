//
//  WatchlistFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/12/2023.
//

import Foundation
import ComposableArchitecture

struct WatchlistFeature: Reducer {
    
    struct State: Equatable {
        var likedMovies: IdentifiedArrayOf<Movie> = []
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case onPreferencesTap
        case onMovieTap(Movie)
        case onMovieLike(Movie)
        case setLikedMovies([LikedMovie])
        case onMovieDislike(Movie)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case confirmDislike(Movie)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .setLikedMovies(likedMovies):
                state.likedMovies = .init(uniqueElements: likedMovies.map { $0.toMovie })
                return .none
                
            case let .onMovieDislike(movie):
                state.alert = AlertState(
                    title: {
                        TextState("Are you sure?")
                    },
                    actions: {
                        ButtonState(role: .destructive, action: .confirmDislike(movie)) {
                            TextState("Remove")
                        }
                        
                        ButtonState(role: .cancel) {
                            TextState("Cancel")
                        }
                    },
                    message: {
                        TextState("Your'e about to remove \(movie.title ?? "") from your watchlist")
                    }
                )
                return .none
                
            case let .alert(.presented(.confirmDislike(movie))):
                return .send(.onMovieLike(movie))
                
            case .alert:
                return .none
                
            // MARK: Handled in parent feature
            case .onPreferencesTap, .onMovieTap, .onMovieLike:
                return .none
            }
        }
        .ifLet(\.$alert, action: /Action.alert)
    }
}
