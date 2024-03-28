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
        var genres: IdentifiedArrayOf<Genre> = []
        var results: IdentifiedArrayOf<Movie> = []
        var searchInput: String = .empty
        
        var isSearchActive: Bool {
            searchInput.count > 2
        }
        
        init() {
            @Dependency(\.appData) var appData // TODO: UseCase
            self.genres = .init(uniqueElements: appData.genres)
        }
    }
    
    enum Action: ViewAction, Equatable, Sendable {
        enum View: Equatable {
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onGenreTap(Genre)
        }
        
        enum Navigation: Equatable {
            case presentMovie(Movie)
            case presentPreferences
        }
        
        case view(View)
        case navigation(Navigation)
        case onInputChange(String)
        case searchMovies(String)
        case searchResponse(Result<MoviesList, TmdbError>)
        case setLikedMovies([LikedMovie])
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    @Dependency(\.database) var database
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerOf<Self> {
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
                guard query == state.searchInput else {
                    return .none
                }
                
                if let genre = state.genres.first(where: { $0.name == query}) {
                    return .run { send in
                        let discoverResult = await tmdbClient.discoverMovies(genre.id)
                        await send(.searchResponse(discoverResult))
                    }
                    
                } else {
                    return .run { send in
                        let searchResult = await tmdbClient.searchMovies(query)
                        await send(.searchResponse(searchResult))
                    }
                }
                
            case let .searchResponse(.success(response)):
                state.isLoading = false
                
                if let movies = response.results {
                    state.results = .init(uniqueElements: movies)
                    
                    let likedMovies = try? database.getLikedMovies()
                    return .send(.setLikedMovies(likedMovies ?? []))
                } else {
                    return .send(.searchResponse(.unknownError))
                }
                
            case let .searchResponse(.failure(error)):
                state.isLoading = false
                
                customDump(error) // TODO: Handle error
                return .none
                
            case let .setLikedMovies(likedMovies):
                let likedMovies = IdentifiedArray(uniqueElements: likedMovies)
                
                for index in state.results.indices where likedMovies[id: state.results[index].id] != nil {
                    state.results[index].isLiked = true
                }
                return .none
                
            case .navigation:
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
            try? database.setMovieLike(movie)
            return .none
        }
    }
}

extension SearchFeature {
    struct SearchInputDebounceId: Hashable {}
}
