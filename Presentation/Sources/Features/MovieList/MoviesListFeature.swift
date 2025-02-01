//
//  MovieListFeature.swift
//  Presentation
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
public struct MovieListFeature {
    
    @ObservableState
    public struct State: Equatable {
        var listType: MovieListType?
        var movies: IdentifiedArrayOf<Movie> = []
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        public init(listType: MovieListType? = nil, movies: IdentifiedArrayOf<Movie>) {
            self.listType = listType
            self.movies = movies
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onMovieTap(Movie)
            case onMovieLike(Movie)
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case presentMovie(Movie)
        }
        
        case view(View)
        case navigation(Navigation)
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .navigation:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case let .onMovieLike(movie):
            return .run { _ in
                await interactor.toggleWatchlist(for: movie)
            }
        }
    }
}

extension DependencyValues {
    fileprivate var interactor: MovieListInteractor {
        get { self[MovieListInteractor.self] }
    }
}
