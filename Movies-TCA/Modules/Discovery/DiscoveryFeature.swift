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
        case setLikedMovies([LikedMovie])
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    @Dependency(\.database) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .loadMovies:
                state.isLoading = true
                
                return .run { send in
                    async let nowPlayingResult = tmdbClient.fetchMovies(.nowPlaying)
                    async let popularResult = tmdbClient.fetchMovies(.popular)
                    async let upcomingResult = tmdbClient.fetchMovies(.upcoming)
                    async let topRatedResult = tmdbClient.fetchMovies(.topRated)

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

                let likedMovies = try? database.getLikedMovies()
                return .send(.setLikedMovies(likedMovies ?? []))
                
            case let .setLikedMovies(likedMovies):
                let likedMovies = IdentifiedArray(uniqueElements: likedMovies)
                
                for listType in state.movies.keys {
                    for index in state.movies[listType]!.indices
                    where likedMovies[id: state.movies[listType]![index].id] != nil {
                        state.movies[listType]![index].isLiked = true
                    }
                }
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
            for listType in state.movies.keys {
                state.movies[listType]?[id: movie.id]?.isLiked.toggle()
            }
            try? database.setMovieLike(movie)
            return .none
        }
    }
}
