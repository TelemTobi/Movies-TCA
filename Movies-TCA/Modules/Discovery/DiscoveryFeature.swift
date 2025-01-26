//
//  DiscoveryFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture

@Reducer
struct DiscoveryFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoading = true
        var movies: [MoviesListType: IdentifiedArrayOf<Movie>] = [:]
        
        @Shared(.likedMovies)
        var likedMovies: IdentifiedArrayOf<Movie> = []
    }
    
    enum Action: ViewAction, Equatable {
        @CasePathable
        enum View: Equatable {
            case onFirstAppear
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onMoviesListTap(MoviesListType, IdentifiedArrayOf<Movie>)
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
            case pushMoviesList(MoviesListType, IdentifiedArrayOf<Movie>)
        }
        
        case view(View)
        case navigation(Navigation)
        case loadMovies
        case moviesListLoaded(MoviesListType, Result<MoviesList, TmdbError>)
        case loadingCompleted
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .loadMovies:
                state.isLoading = true
                
                return .run { send in
                    async let nowPlayingResult = tmdbClient.fetchMovies(ofType: .nowPlaying)
                    async let popularResult = tmdbClient.fetchMovies(ofType: .popular)
                    async let upcomingResult = tmdbClient.fetchMovies(ofType: .upcoming)
                    async let topRatedResult = tmdbClient.fetchMovies(ofType: .topRated)

                    await send(.moviesListLoaded(.nowPlaying, nowPlayingResult))
                    await send(.moviesListLoaded(.popular, popularResult))
                    await send(.moviesListLoaded(.upcoming, upcomingResult))
                    await send(.moviesListLoaded(.topRated, topRatedResult))
                    
                    await send(.loadingCompleted)
                }
                
            case let .moviesListLoaded(type, .success(response)):
                if let movies = response.results {
                    state.movies[type] = .init(uniqueElements: movies)
                    return .none
                } else {
                    return .send(.moviesListLoaded(type, .unknownError))
                }
                
            case let .moviesListLoaded(_, .failure(error)):
                customDump(error) // TODO: Handle error
                return .none
                
            case .loadingCompleted:
                state.isLoading = false
                return .none
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onFirstAppear:
            return .send(.loadMovies)
            
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case .onPreferencesTap:
            return .send(.navigation(.presentPreferences))
            
        case let .onMoviesListTap(listType, movies):
            return .send(.navigation(.pushMoviesList(listType, movies)))
            
        case let .onMovieLike(movie):
            if state.likedMovies.contains(movie) {
                state.$likedMovies.withLock { $0.remove(movie) }
            } else {
                state.$likedMovies.withLock { $0.append(movie) }
            }
            return .none
        }
    }
}
