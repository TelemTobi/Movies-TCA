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
            searchInput.isNotEmpty
        }
    }
    
    enum Action: Equatable, BindableAction {
        case onFirstAppear
        case onMovieTap(_ movie: Movie)
        case onGenreTap(_ genre: Genre)
        case resultsResponse(Result<MoviesList, TmdbError>)
        
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onFirstAppear:
                return .none
                
            case .binding(_):
                return .none
                
            case let .onGenreTap(genre):
                state.searchInput = genre.name ?? .empty
                state.isLoading = true
                
                return .run { send in
                    let discoverResult = await tmdbClient.discoverMovies(genre.id)
                    await send(.resultsResponse(discoverResult))
                }
                
            case let .resultsResponse(.success(response)):
                state.isLoading = false
                
                if let movies = response.results {
                    customDump(movies)
                    state.results = .init(uniqueElements: movies)
                } else {
                    return .send(.resultsResponse(.unknownError))
                }
                
                return .none
                
            case let .resultsResponse(.failure(error)):
                state.isLoading = false
                
                customDump(error) // TODO: Handle error
                return .none
                
            // MARK: Handled in parent feature
            case .onMovieTap:
                return .none
                
            }
        }
    }
}
