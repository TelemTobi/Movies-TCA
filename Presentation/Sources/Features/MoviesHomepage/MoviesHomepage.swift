//
//  MoviesHomepage.swift
//  Presentation
//
//  Created by Telem Tobi on 11/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture
import Models
import DesignSystem

@Reducer
public struct MoviesHomepage {
    
    @ObservableState
    public struct State: Equatable {
        var viewState: ViewState
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        public init(viewState: ViewState = .loading) {
            self.viewState = viewState
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onFirstAppear
            case onPreferencesTap
            case onMovieTap(Movie, TransitionSource)
            case onMovieLike(Movie)
            case onMovieListTap(MovieListType, IdentifiedArrayOf<Movie>)
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case presentMovie(Movie, TransitionSource)
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
                state.viewState = .loading
                
                return .run { send in
                    let result = await interactor.fetchMovieLists(
                        ofTypes: .nowPlaying, .upcoming, .popular, .topRated
                    )
                    await send(.movieListsResult(result))
                }
                
            case let .movieListsResult(result):
                state.viewState = .loaded(
                    result.compactMapValues { result in
                        guard let movies = try? result.get().movies else { return nil }
                        return .init(uniqueElements: movies)
                    }
                )
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
            
        case let .onMovieTap(movie, transitionSource):
            return .send(.navigation(.presentMovie(movie, transitionSource)))
            
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

public extension MoviesHomepage {
    enum ViewState: Equatable {
        case loading
        case loaded([MovieListType: IdentifiedArrayOf<Movie>])
    }
}

extension DependencyValues {
    fileprivate var interactor: MoviesHomepageInteractor {
        get { self[MoviesHomepageInteractor.self] }
    }
}
