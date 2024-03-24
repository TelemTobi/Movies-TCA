//
//  WatchlistNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct WatchlistNavigator {
    
    @ObservableState
    struct State: Equatable {
        var root = WatchlistFeature.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case root(WatchlistFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: WatchlistFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.presentMovie(movie))):
                state.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case .root(.navigation(.presentPreferences)):
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case .root, .path, .destination:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

extension WatchlistNavigator {
        
    @Reducer(state: .equatable)
    enum Destination {
        case movie(MovieFeature)
        case preferences(PreferencesFeature)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        
    }
}
