//
//  DiscoverFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import ComposableArchitecture

struct DiscoverFeature: Reducer {
    
    struct State: Equatable {
        var path = StackState<Path.State>()
        
        var isLoading = true
        var movies: [MoviesListType: IdentifiedArrayOf<Movie>] = [:]
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        
        case onFirstAppear
        case onPreferencesTap
        case onMovieTap(_ movie: Movie)
        case onMoviesListTap(_ listType: MoviesListType, _ movies: IdentifiedArrayOf<Movie>)
        
        case loadMovies
        case moviesListLoaded(type: MoviesListType, Result<MoviesList, TmdbError>)
        case loadingCompleted
        
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
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .send(.loadMovies)
                
            case .loadMovies:
                state.isLoading = true
                
                return .run { send in
                    async let nowPlayingResult = tmdbClient.fetchMovies(.nowPlaying)
                    async let popularResult = tmdbClient.fetchMovies(.popular)
                    async let upcomingResult = tmdbClient.fetchMovies(.upcoming)
                    async let topRatedResult = tmdbClient.fetchMovies(.topRated)

                    await send(.moviesListLoaded(type: .nowPlaying, nowPlayingResult))
                    await send(.moviesListLoaded(type: .popular, popularResult))
                    await send(.moviesListLoaded(type: .upcoming, upcomingResult))
                    await send(.moviesListLoaded(type: .topRated, topRatedResult))
                    
                    await send(.loadingCompleted)
                }
                
            case let .moviesListLoaded(type, .success(response)):
                if let movies = response.results {
                    state.movies[type] = .init(uniqueElements: movies)
                    return .none
                } else {
                    return .send(.moviesListLoaded(type: type, .unknownError))
                }
                
            case let .moviesListLoaded(_, .failure(error)):
                customDump(error) // TODO: Handle error
                return .none
                
            case .loadingCompleted:
                state.isLoading = false
                return .none
                
            case let .onMoviesListTap(listType, movies):
                let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
                state.path.append(.moviesList(moviesListState))
                return .none
                
            case .path:
                return .none
                
            // MARK: Handled in parent feature
            case .onPreferencesTap, .onMovieTap:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            Path()
        }
    }
}
