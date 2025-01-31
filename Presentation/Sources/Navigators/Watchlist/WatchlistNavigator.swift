//
//  WatchlistNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 24/03/2024.
//

import Foundation
import ComposableArchitecture
import WatchlistFeature
import PreferencesFeature
import MovieNavigator

@Reducer
public struct WatchlistNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var root = WatchlistFeature.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        
        public init(path: StackState<Path.State> = .init(), destination: Destination.State? = nil) {
            self.path = path
            self.destination = destination
        }
        
    }
    
    public enum Action {
        case root(WatchlistFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: WatchlistFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.presentMovie(movie))):
                state.destination = .movie(MovieNavigator.State(movieDetails: .init(movie: movie)))
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
    public enum Destination {
        case movie(MovieNavigator)
        case preferences(PreferencesFeature)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        
    }
}
