//
//  SearchFeature.swift
//  Presentation
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture
import Models

@Reducer
public struct SearchFeature {
    
    @ObservableState
    public struct State: Equatable {
        var isLoading: Bool
        var results: IdentifiedArrayOf<Movie>
        var searchInput: String

        @Shared(.genres) var genres = []
        @Shared(.watchlist) var watchlist: IdentifiedArrayOf<Movie> = []
        
        var isSearchActive: Bool {
            searchInput.count >= 2
        }
        
        public init(isLoading: Bool = false, results: IdentifiedArrayOf<Movie> = [], searchInput: String = "") {
            self.isLoading = isLoading
            self.results = results
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
        case binding(BindingAction<SearchFeature.State>)
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
                state.isLoading = state.isSearchActive
                
                guard state.isSearchActive else {
                    state.results = []
                    return .none
                }
                
                return .send(.searchMovies(input))
                    .debounce(id: SearchInputDebounceId(), for: .seconds(1), scheduler: mainQueue)
                
            case let .searchMovies(query):
                if let genre = state.genres.first(where: { $0.name == query }) {
                    return .run { send in
                        let discoverResult = await interactor.discoverMovies(by: genre.id)
                        await send(.searchResult(discoverResult))
                    }
                    
                } else {
                    return .run { send in
                        let searchResult = await interactor.searchMovies(using: query)
                        await send(.searchResult(searchResult))
                    }
                }
                
            case let .searchResult(result):
                state.isLoading = false
                
                switch result {
                case let .success(response):
                    state.results = .init(uniqueElements: response.movies ?? [])
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
            guard let genreName = genre.name else {
                return .none
            }
            
            state.searchInput = genreName
            state.isLoading = true
            
            return .send(.searchMovies(genreName))
            
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

extension SearchFeature {
    struct SearchInputDebounceId: Hashable {}
}

extension DependencyValues {
    fileprivate var interactor: SearchInteractor {
        get { self[SearchInteractor.self] }
    }
}
