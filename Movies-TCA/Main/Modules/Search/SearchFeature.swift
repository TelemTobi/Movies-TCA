//
//  SearchFeature.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import Foundation
import ComposableArchitecture

struct SearchFeature: Reducer {
    
    struct State: Equatable {
        var isLoading = false
        var genres: IdentifiedArrayOf<Genre> = []
        var results: IdentifiedArrayOf<Movie> = []

        @BindingState var searchInput: String = ""
        
        var isSearchActive: Bool {
            searchInput.count > 2
        }
    }
    
    enum Action: Equatable, BindableAction {
        case onFirstAppear
        case onMovieTap(_ movie: Movie)
        case onGenreTap(_ genre: Genre)
        case searchMovies(_ query: String)
        case searchResponse(Result<MoviesList, TmdbError>)
        
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
                
            case .binding(\.$searchInput):
                state.isLoading = state.isSearchActive
                
                guard state.isSearchActive else {
                    state.results = []
                    return .none
                }

                let input = state.searchInput
                
                return .run { send in
                    try? await Task.sleep(until: .now + .seconds(1))
                    await send(.searchMovies(input))
                }
                
            case let .onGenreTap(genre):
                guard let genreName = genre.name else {
                    return .none
                }
                
                state.searchInput = genreName
                state.isLoading = true
                
                return .send(.searchMovies(genreName))
                
            case let .searchMovies(query):
                guard query == state.searchInput else {
                    return .none
                }
                
                print("👀 " + query)
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
                } else {
                    return .send(.searchResponse(.unknownError))
                }
                
                return .none
                
            case let .searchResponse(.failure(error)):
                state.isLoading = false
                
                customDump(error) // TODO: Handle error
                return .none
                
            case .binding(_):
                return .none
                
            // MARK: Handled in parent feature
            case .onMovieTap:
                return .none
                
            }
        }
    }
}
