//
//  DiscoverFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture

@Reducer
struct DiscoverFeature {
    
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        
        var isLoading = true
        var movies: [MoviesListType: IdentifiedArrayOf<Movie>] = [:]
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        
        case onFirstAppear
        case onPreferencesTap
        case onMovieTap(Movie)
        case onMovieLike(Movie)
        case onMoviesListTap(MoviesListType, IdentifiedArrayOf<Movie>)
        
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
            case .onFirstAppear:
                return .send(.loadMovies)
                
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

                let likedMovies = try? database.context().fetch(FetchDescriptor<LikedMovie>())
                return .send(.setLikedMovies(likedMovies ?? []))
                
            case let .onMoviesListTap(listType, movies):
                let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
                state.path.append(.moviesList(moviesListState))
                return .none
                
            case let .setLikedMovies(likedMovies):
                let likedMovies = IdentifiedArray(uniqueElements: likedMovies)
                
                for listType in state.movies.keys {
                    for index in state.movies[listType]!.indices
                    where likedMovies[id: state.movies[listType]![index].id] != nil {
                        state.movies[listType]![index].isLiked = true
                    }
                }
                return .none
                
            case .path:
                return .none
                
            // MARK: Handled in parent feature
            case .onPreferencesTap, .onMovieTap, .onMovieLike:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension DiscoverFeature {
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case moviesList(MoviesListFeature)
    }
}
