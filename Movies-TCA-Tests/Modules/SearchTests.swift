//
//  SearchTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 28/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class SearchTests: XCTestCase {
    
    var store = TestStore(
        initialState: SearchFeature.State(),
        reducer: { SearchFeature() },
        withDependencies: {
            $0.mainQueue = .immediate
        }
    )
    
    func testOnInputChange() async {
        // Short search input
        await store.send(.onInputChange("Hi")) { state in
            state.searchInput = "Hi"
        }
        
        // Valid search input
        await store.send(.onInputChange("Hello")) { state in
            state.searchInput = "Hello"
            state.isLoading = true
        }
        
        await store.receive(\.searchMovies, "Hello")
        
        let searchResult = await store.dependencies.tmdbClient.searchMovies("Hello")
        guard case let .success(response) = searchResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        await store.receive(\.searchResponse) { state in
            state.isLoading = false
            state.results = .init(uniqueElements: response.results ?? [])
        }
        await store.receive(\.setLikedMovies)
        
        // Empty search input
        await store.send(.onInputChange("")) { state in
            state.searchInput = ""
            state.isLoading = false
            state.results = []
        }
    }
    
    func testSearchMovies() async {
        // Genre tap
        let genreResult = await store.dependencies.tmdbClient.discoverMovies(18)
        guard case let .success(response) = genreResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        await store.send(.searchMovies("Action"))
        await store.receive(\.searchResponse, genreResult) { state in
            state.results = .init(uniqueElements: response.results ?? [])
        }
        
        await store.receive(\.setLikedMovies)
        
        // Free search
        let searchResult = await store.dependencies.tmdbClient.searchMovies("Test")
        guard case let .success(response) = searchResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        await store.send(.searchMovies("Test"))
        await store.receive(\.searchResponse, searchResult) { state in
            state.results = .init(uniqueElements: response.results ?? [])
        }
        
        await store.receive(\.setLikedMovies)
    }
    
    func testSearchResponse() async {
        // Error response
        let invalidMovieList = MoviesList(results: nil, page: nil, totalPages: nil, totalResults: nil)
        await store.send(.searchResponse(.success(invalidMovieList)))
        await store.receive(\.searchResponse, .unknownError)
        
        await store.send(.binding(.set(\.isLoading, true))) { $0.isLoading = true }
        await store.send(.searchResponse(.unknownError)) { state in
            state.isLoading = false
        }
        
        // Success response
        let successResult = await store.dependencies.tmdbClient.searchMovies("Test..")
        guard case let .success(response) = successResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        await store.send(.binding(.set(\.isLoading, true))) { $0.isLoading = true }
        await store.send(.searchResponse(successResult)) { state in
            state.isLoading = false
            state.results = .init(uniqueElements: response.results ?? [])
        }
        
        await store.receive(\.setLikedMovies)
    }
    
    // MARK: - View Actions
    
    func testOnGenreTap() async {
        // Invalid genre
        let noNameGenre = Genre(id: 0, name: nil)
        await store.send(.view(.onGenreTap(noNameGenre)))
        
        // Valid genre
        let genre = Genre.mock
        await store.send(.view(.onGenreTap(genre))) { state in
            state.searchInput = genre.name ?? .empty
            state.isLoading = true
        }
        
        await store.receive(\.searchMovies, genre.name ?? .empty)
    }
    
    func testOnMovieTap() async {
        await store.send(.view(.onMovieTap(.mock)))
        await store.receive(\.navigation)
    }
    
    func testOnPreferencesTap() async {
        await store.send(.view(.onPreferencesTap))
        await store.receive(\.navigation)
    }
}
