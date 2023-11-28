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
        var isLoading = true
        var movies: [MoviesList.ListType: IdentifiedArrayOf<Movie>] = [:]
        
        @PresentationState var movie: MovieFeature.State?
    }
    
    enum Action: Equatable {
        case onFirstAppear
        case loadMovies
        case moviesListLoaded(type: MoviesList.ListType, Result<MoviesList, TmdbError>)
        case loadingCompleted
        
        case onMovieTap(_ movie: Movie)
        case onCloseMovieTap
        case onMoviesListTap(_ listType: MoviesList.ListType, _ movies: IdentifiedArrayOf<Movie>)
        
        case movie(PresentationAction<MovieFeature.Action>)
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
                    await send(.moviesListLoaded(type: .nowPlaying, nowPlayingResult))
                    
                    async let popularResult = tmdbClient.fetchMovies(.popular)
                    await send(.moviesListLoaded(type: .popular, popularResult))
                    
                    async let topRatedResult = tmdbClient.fetchMovies(.topRated)
                    await send(.moviesListLoaded(type: .topRated, topRatedResult))
                    
                    async let upcomingResult = tmdbClient.fetchMovies(.upcoming)
                    await send(.moviesListLoaded(type: .upcoming, upcomingResult))
                    
                    await send(.loadingCompleted)
                }
                
            case let .moviesListLoaded(type, .success(response)):
                if let movies = response.results {
                    state.movies[type] = .init(uniqueElements: movies)
                } else {
                    return .send(.moviesListLoaded(type: type, .unknownError))
                }
                
                return .none
                
            case let .moviesListLoaded(_, .failure(error)):
                customDump(error) // TODO: Handle error
                return .none
                
            case .loadingCompleted:
                state.isLoading = false
                return .none
                
            case let .onMovieTap(movie):
                state.movie = MovieFeature.State(movie: movie)
                return .none
                
            case .onCloseMovieTap:
                state.movie = nil
                return .none
                
            case .onMoviesListTap:
                return .none // Handled in parent feature
                
            case .movie:
                return .none
            }
        }
        .ifLet(\.$movie, action: /Action.movie) {
            MovieFeature()
        }
    }
}
