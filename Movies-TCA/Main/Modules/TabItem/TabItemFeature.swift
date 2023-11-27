//
//  TabItemFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture

struct TabItemFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        
        var discover = DiscoverFeature.State()
        var search = SearchFeature.State()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
    }
    
    struct Path: Reducer {
        
        enum State: Equatable {
            case moviesList(MoviesListFeature.State)
        }
        
        enum Action: Equatable {
            case moviesList(MoviesListFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.moviesList, action: /Action.moviesList) {
                MoviesListFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.discover, action: /Action.discover) {
            DiscoverFeature()
        }

        Scope(state: \.search, action: /Action.search) {
            SearchFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case let .discover(action):
                switch action {
                case let .onMoviesListTap(listType, movies):
                    let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
                    state.path.append(Path.State.moviesList(moviesListState))
                    return .none
                default:
                    return .none
                }
                
            case .search:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
