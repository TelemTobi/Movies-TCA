//
//  DiscoverNavigator.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 17/03/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DiscoverNavigator {
    
    @ObservableState
    struct State: Equatable {
        var root = DiscoverFeature.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case root(DiscoverFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: DiscoverFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.presentMovie(movie))):
                state.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
                return .none
                
            case .root(.navigation(.presentPreferences)):
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case let .root(.navigation(.pushMoviesList(listType, movies))):
                let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
                state.path.append(.moviesList(moviesListState))
                return .none
                
            case .root, .path, .destination:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

extension DiscoverNavigator {
        
    @Reducer(state: .equatable)
    enum Destination {
        case movie(MovieFeature)
        case preferences(PreferencesFeature)
    }
    
    @Reducer(state: .equatable)
    enum Path {
        case moviesList(MoviesListFeature)
    }
}
