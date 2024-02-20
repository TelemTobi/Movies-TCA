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
    }
    
    enum Action: ViewAction, Equatable {
        enum View: Equatable {
            case onFirstAppear
            case onPreferencesTap
            case onMovieTap(Movie)
            case onMovieLike(Movie)
            case onGenreTap(Genre)
        }
        
        case view(View)
        case onInputChange(String)
        case searchMovies(String)
        case searchResponse(Result<MoviesList, TmdbError>)
        case setLikedMovies([LikedMovie])
    }
    
    @Dependency(\.tmdbClient) var tmdbClient
    @Dependency(\.database) var database
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onFirstAppear):
                return .none
                
            case let .onInputChange(input):
                state.searchInput = input
                state.isLoading = state.isSearchActive
                
                guard state.isSearchActive else {
                    state.results = []
                    return .none
                }
                
                return .run { send in
                    try? await Task.sleep(until: .now + .seconds(1))
                    await send(.searchMovies(input))
                }
                
            case let .view(.onGenreTap(genre)):
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
                    
                    let likedMovies = try? database.context().fetch(FetchDescriptor<LikedMovie>())
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
                
            // MARK: Handled in parent feature
            case .view(.onPreferencesTap), .view(.onMovieTap), .view(.onMovieLike):
                return .none
            }
        }
    }
}
