//
//  GenreDetails.swift
//  Presentation
//
//  Created by Telem Tobi on 13/02/2025.
//

import Foundation
import ComposableArchitecture
import Models
import MovieCollectionFeature

@Reducer
public struct GenreDetails {
    
    @ObservableState
    public struct State: Equatable {
        let genre: Genre
        var viewState: ViewState = .loading
        var movieCollection: MovieCollection.State?
        
        public init(genre: Genre) {
            self.genre = genre
        }
    }
    
    public enum Action: ViewAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onAppear
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            
        }
        
        case view(View)
        case navigation(Navigation)
        case movieCollection(MovieCollection.Action)
        case discoverMovies
        case discoveryResult(Result<MovieList, TmdbError>)
    }
    
    @Dependency(\.interactor) private var interactor
    
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case .discoverMovies:
                return .run { [genre = state.genre] send in
                    let result = await interactor.discoverByGenre(genre)
                    await send(.discoveryResult(result))
                }
                
            case let .discoveryResult(result):
                switch result {
                case let .success(movieList):
                    state.movieCollection = .init(
                        movieList: movieList,
                        title: state.genre.description,
                        layout: .grid
                    )
                    state.viewState = .loaded
                    return .none
                    
                case .failure:
                    state.viewState = .error
                    return .none
                }
                
            case .navigation, .movieCollection:
                return .none
            }
        }
        .ifLet(\.movieCollection, action: \.movieCollection) {
            MovieCollection()
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.discoverMovies)
        }
    }
}

extension GenreDetails {
    enum ViewState: Equatable {
        case loading
        case loaded
        case error
    }
}

extension DependencyValues {
    fileprivate var interactor: GenreDetailsInteractor {
        get { self[GenreDetailsInteractor.self] }
    }
}
