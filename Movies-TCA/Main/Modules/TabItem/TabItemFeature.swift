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
        
        @PresentationState var presentedMovie: MovieFeature.State?
        @PresentationState var preferences: PreferencesFeature.State?
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case discover(DiscoverFeature.Action)
        case search(SearchFeature.Action)
        
        case presentedMovie(PresentationAction<MovieFeature.Action>)
        case preferences(PresentationAction<PreferencesFeature.Action>)

        case setGenres(IdentifiedArrayOf<Genre>)
        case onPreferencesTap
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
                
            case let .discover(.onMovieTap(movie)), let .search(.onMovieTap(movie)):
                state.presentedMovie = MovieFeature.State(movie: movie)
                return .none
                
            case let .discover(.onMoviesListTap(listType, movies)):
                let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
                state.path.append(.moviesList(moviesListState))
                return .none
                
            case let .setGenres(genres):
                state.search.genres = genres
                return .none
                
            case .onPreferencesTap:
                state.preferences = PreferencesFeature.State()
                return .none
                
            case .discover, .search, .presentedMovie, .preferences:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
        .ifLet(\.$presentedMovie, action: /Action.presentedMovie) {
            MovieFeature()
        }
        .ifLet(\.$preferences, action: /Action.preferences) {
            PreferencesFeature()
        }
    }
}
