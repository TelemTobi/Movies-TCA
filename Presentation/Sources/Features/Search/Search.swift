//
//  Search.swift
//  Presentation
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture
import Models

@Reducer
public struct Search {
    
    @ObservableState
    public struct State: Equatable {
        var viewState: ViewState = .suggestions
        var searchInput: String

        @Shared(.genres) var genres = []
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        var isSearchActive: Bool {
            searchInput.count >= 2
        }
        
        public init(searchInput: String = "") {
            self.searchInput = searchInput
        }
    }
    
    public enum Action: ViewAction, BindableAction, Equatable {
        @CasePathable
        public enum View: Equatable {
            case onPreferencesTap
            case onMovieTap(Movie)
            case onGenreTap(Genre)
            case onMovieLike(Movie)
        }
        
        @CasePathable
        public enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
        }
        
        case view(View)
        case navigation(Navigation)
        case binding(BindingAction<Search.State>)
        case onInputChange(String)
        case searchMovies(String)
        case searchResult(Result<MovieList, TmdbError>)
    }
    
    @Dependency(\.interactor) private var interactor
    @Dependency(\.mainQueue) private var mainQueue
    
    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return reduceViewAction(&state, viewAction)
                
            case let .onInputChange(input):
                state.searchInput = input
                
                guard state.isSearchActive else {
                    state.viewState = .suggestions
                    return .none
                }
                
                state.viewState = .loading
                
                return .send(.searchMovies(input))
                    .debounce(for: .textInput)
                
            case let .searchMovies(query):
                if let genre = state.genres.first(where: { $0.description == query }) {
                    return .run { send in
                        let discoverResult = await interactor.discoverMovies(by: genre.rawValue)
                        await send(.searchResult(discoverResult))
                    }
                    .debounce(for: .loading)
                    
                } else {
                    return .run { send in
                        let searchResult = await interactor.searchMovies(using: query)
                        await send(.searchResult(searchResult))
                    }
                }
                
            case let .searchResult(result):
                switch result {
                case let .success(response):
                    if let movies = response.movies, movies.isNotEmpty {
                        state.viewState = .searchResult(.init(uniqueElements: movies))
                    } else {
                        // TODO: Handle empty state
                    }
                    return .none
                    
                case let .failure(error):
                    customDump(error) // TODO: Handle error
                    return .none
                }
                
            case .navigation, .binding:
                return .none
            }
        }
    }
    
    private func reduceViewAction(_ state: inout State, _ action: Action.View) -> Effect<Action> {
        switch action {
        case let .onGenreTap(genre):
            state.searchInput = genre.description
            state.viewState = .loading
            return .send(.searchMovies(genre.description))
            
        case let .onMovieTap(movie):
            return .send(.navigation(.presentMovie(movie)))
            
        case .onPreferencesTap:
            return .send(.navigation(.presentPreferences))
            
        case let .onMovieLike(movie):
            return .run { _ in
                await interactor.toggleWatchlist(for: movie)
            }
        }
    }
}

extension Search {
    enum ViewState: Equatable {
        case suggestions
        case loading
        case searchResult(IdentifiedArrayOf<Movie>)
    }
}

extension DependencyValues {
    fileprivate var interactor: SearchInteractor {
        get { self[SearchInteractor.self] }
    }
}
