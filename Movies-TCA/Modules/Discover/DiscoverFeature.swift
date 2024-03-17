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
//        var path = StackState<Path.State>()
        
        var isLoading = true
        var movies: [MoviesListType: IdentifiedArrayOf<Movie>] = [:]
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case onFirstAppear
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onMoviesListTap(MoviesListType, IdentifiedArrayOf<Movie>)
        }
        
        enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
        }
        
        case view(View)
        case navigation(Navigation)
//        case path(StackAction<Path.State, Path.Action>)
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

                let likedMovies = try? database.context().fetch(FetchDescriptor<LikedMovie>())
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
//            case .path:
//                return .none
            }
        }
//        .forEach(\.path, action: \.path)
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
//            let moviesListState = MoviesListFeature.State(listType: listType, movies: movies)
//            state.path.append(.moviesList(moviesListState))
            return .none
            
        case let .onMovieLike(movie):
            // TODO: Extract to a UseCase ⚠️
            if movie.isLiked {
                let likedMovie = LikedMovie(movie)
                try? database.context().insert(likedMovie)
            } else {
                let movieId = movie.id
                try? database.context().delete(
                    model: LikedMovie.self,
                    where: #Predicate { $0.id == movieId }
                )
            }
            return .none
        }
    }
}

//extension DiscoverFeature {
//    
//    @Reducer(state: .equatable, action: .equatable)
//    enum Path {
//        case moviesList(MoviesListFeature)
//    }
//}
