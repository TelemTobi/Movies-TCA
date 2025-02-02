//
//  Discovery.swift
//  Presentation
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture
import Models

@Reducer
public struct Discovery {
    
    @ObservableState
    public struct State: Equatable {
        var isLoading = true
        var movies: [MovieListType: IdentifiedArrayOf<Movie>] = [:]
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        public init(isLoading: Bool = true, movies: [MovieListType : IdentifiedArrayOf<Movie>] = [:]) {
            self.isLoading = isLoading
            self.movies = movies
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onFirstAppear
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onMovieListTap(MovieListType, IdentifiedArrayOf<Movie>)
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
            case pushMovieList(MovieListType, IdentifiedArrayOf<Movie>)
        }
        
        case view(View)
        case navigation(Navigation)
        case fetchMovieLists
        case movieListsResult([MovieListType: Result<MovieList, TmdbError>])
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .fetchMovieLists:
                state.isLoading = true
                
                return .run { send in
                    let result = await interactor.fetchMovieLists(ofTypes: MovieListType.allCases)
                    await send(.movieListsResult(result))
                }
                
            case let .movieListsResult(result):
                state.movies = result.compactMapValues { result in
                    guard let movies = try? result.get().movies else { return nil }
                    return .init(uniqueElements: movies)
                }
                
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
            return .send(.fetchMovieLists)
            
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case .onPreferencesTap:
            return .send(.navigation(.presentPreferences))
            
        case let .onMovieListTap(listType, movies):
            return .send(.navigation(.pushMovieList(listType, movies)))
            
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
