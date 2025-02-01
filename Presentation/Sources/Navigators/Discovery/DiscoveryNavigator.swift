//
//  DiscoveryNavigator.swift
//  Presentation
//
//  Created by Telem Tobi on 17/03/2024.
//

import Foundation
import ComposableArchitecture
import DiscoveryFeature
import MovieListFeature
import PreferencesFeature
import MovieNavigator

@Reducer
public struct DiscoveryNavigator {
    
    @ObservableState
    public struct State: Equatable {
        var root = DiscoveryFeature.State()
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        
        public init(path: StackState<Path.State> = StackState<Path.State>(), destination: Destination.State? = nil) {
            self.path = path
            self.destination = destination
        }
    }
    
    public enum Action {
        case root(DiscoveryFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.root, action: \.root, child: DiscoveryFeature.init)
        
        Reduce { state, action in
            switch action {
            case let .root(.navigation(.presentMovie(movie))),
                let .path(.element(_, action: .movieList(.navigation(.presentMovie(movie))))):
                state.destination = .movie(MovieNavigator.State(movieDetails: .init(movie: movie)))
                return .none
                
            case .root(.navigation(.presentPreferences)):
                state.destination = .preferences(PreferencesFeature.State())
                return .none
                
            case let .root(.navigation(.pushMovieList(listType, movies))):
                let movieListState = MovieListFeature.State(listType: listType, movies: movies)
                state.path.append(.movieList(movieListState))
                return .none
                
            case .root, .path, .destination:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$destination, action: \.destination)
    }
}

extension DiscoveryNavigator {
        
    @Reducer(state: .equatable)
    public enum Destination {
        case movie(MovieNavigator)
        case preferences(PreferencesFeature)
    }
    
    @Reducer(state: .equatable)
    public enum Path {
        case movieList(MovieListFeature)
    }
}
