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
                state.alert = .dislikeConfirmation(for: movie)
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
        .ifLet(\.$alert, action: \.alert)
    }
}
