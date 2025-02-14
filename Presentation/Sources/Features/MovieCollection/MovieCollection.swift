//
//  MovieCollection.swift
//  Presentation
//
//  Created by Telem Tobi on 26/11/2023.
//

import Foundation
import ComposableArchitecture
import Models
import DesignSystem

@Reducer
public struct MovieCollection {
    
    @ObservableState
    public struct State: Equatable {
        let section: HomepageSection
        let movieList: MovieList
        
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        @Shared(.genres) fileprivate var genres: [Genre] = []
        
        var collectionLayout: CollectionLayout {
            switch section {
            case .watchlist: .list(editable: true)
            case .popular, .topRated: .list(editable: false)
            case .nowPlaying, .upcoming: .grid
            default: .grid
            }
        }
        
        public init(section: HomepageSection, movieList: MovieList) {
            self.section = section
            self.movieList = movieList
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onToggleWatchlist(Movie)
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
            
        case let .onToggleWatchlist(movie):
            return .run { _ in
                await interactor.toggleWatchlist(for: movie)
            }
        }
    }
}

public extension MovieCollection {
    enum CollectionLayout {
        case list(editable: Bool)
        case grid
    }
}

extension DependencyValues {
    fileprivate var interactor: MovieCollectionInteractor {
        get { self[MovieCollectionInteractor.self] }
    }
}
