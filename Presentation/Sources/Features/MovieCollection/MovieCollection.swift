//
//  MovieCollection.swift
//  Presentation
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture
import Models

@Reducer
public struct MovieCollection {
    
    @ObservableState
    public struct State: Equatable {
        let collectionLayout: CollectionLayout
        let listType: MovieListType?
        let movies: IdentifiedArrayOf<Movie>
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        @Shared(.genres) fileprivate var genres: [Genre] = []
        
        public init(collectionType: CollectionLayout = .list, listType: MovieListType? = nil, movies: IdentifiedArrayOf<Movie>) {
            self.collectionLayout = collectionType
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

public extension MovieCollection {
    enum CollectionLayout {
        case list, grid
    }
}

extension DependencyValues {
    fileprivate var interactor: MovieCollectionInteractor {
        get { self[MovieCollectionInteractor.self] }
    }
}
