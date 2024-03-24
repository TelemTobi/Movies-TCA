//
//  SearchNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 20/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchNavigator {
    
    @ObservableState
    struct State: Equatable {
        var root = SearchFeature.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case root(SearchFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: SearchFeature.init)
        
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

extension SearchNavigator {
        
    @Reducer(state: .equatable)
    enum Destination {
        case movie(MovieNavigator)
        case preferences(PreferencesFeature)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        
    }
}
