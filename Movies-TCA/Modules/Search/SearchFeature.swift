//
//  SearchFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import SwiftData
import ComposableArchitecture

@Reducer
struct SearchFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var results: IdentifiedArrayOf<Movie> = []
        var searchInput: String = .empty

        @Shared(.genres) var genres = []
        @Shared(.likedMovies) var likedMovies: IdentifiedArrayOf<Movie> = []
        
        var isSearchActive: Bool {
            searchInput.count >= 2
        }
    }
    
    enum Action: ViewAction, BindableAction, Equatable, Sendable {
        @CasePathable
        enum View: Equatable {
            case onPreferencesTap
            case onMovieTap(Movie)
            case onGenreTap(Genre)
            case onMovieLike(Movie)
        }
        
        @CasePathable
        enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
        }
        
        case view(View)
        case navigation(Navigation)
        case binding(BindingAction<SearchFeature.State>)
        case onInputChange(String)
        case searchMovies(String)
        case searchResponse(Result<MoviesList, TmdbError>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerOf<Self> {
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
                if let genre = state.genres.first(where: { $0.name == query}) {
                    return .run { send in
                        let discoverResult = await tmdbClient.discoverMovies(by: genre.id)
                        await send(.searchResponse(discoverResult))
                    }
                    
                } else {
                    return .run { send in
                        let searchResult = await tmdbClient.searchMovies(query: query)
                        await send(.searchResponse(searchResult))
                    }
                }
                
            case let .searchResponse(.success(response)):
                state.isLoading = false
                
                guard let movies = response.results else {
                    return .send(.searchResponse(.unknownError))
                }
                
                state.results = .init(uniqueElements: movies)
                return .none
                
            case let .searchResponse(.failure(error)):
                state.isLoading = false
                
                customDump(error) // TODO: Handle error
                return .none
                
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
            if state.likedMovies.contains(movie) {
                state.$likedMovies.withLock { $0.remove(movie) }
            } else {
                state.$likedMovies.withLock { $0.append(movie) }
            }
            return .none
        }
    }
}

extension SearchFeature {
    struct SearchInputDebounceId: Hashable {}
}
