//
//  DiscoveryFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture
import Models
import Domain

@Reducer
struct DiscoveryFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoading = true
        var movies: [MoviesListType: IdentifiedArrayOf<Movie>] = [:]
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
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
        case movieListResult(MoviesListType, Result<MovieList, TmdbError>)
        case loadingCompleted
    }
    
    @Dependency(\.interactor) private var interactor
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .loadMovies:
                state.isLoading = true
                
                return .run { send in
                    async let nowPlayingResult = interactor.fetchMovieList(ofType: .nowPlaying)
                    async let popularResult = interactor.fetchMovieList(ofType: .popular)
                    async let upcomingResult = interactor.fetchMovieList(ofType: .upcoming)
                    async let topRatedResult = interactor.fetchMovieList(ofType: .topRated)

                    await send(.movieListResult(.nowPlaying, nowPlayingResult))
                    await send(.movieListResult(.popular, popularResult))
                    await send(.movieListResult(.upcoming, upcomingResult))
                    await send(.movieListResult(.topRated, topRatedResult))
                    
                    await send(.loadingCompleted)
                }
                
            case let .movieListResult(type, result):
                switch result {
                case let .success(response):
                    state.movies[type] = .init(uniqueElements: response.movies ?? [])
                    return .none
                    
                case let .failure(error):
                    customDump(error) // TODO: Handle error
                }
                
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
            return .run { _ in
                await interactor.toggleWatchlist(for: movie)
            }
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: DiscoveryInteractor {
        get { self[DiscoveryInteractor.self] }
    }
}
