//
//  SearchTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 28/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import SearchFeature
@testable import Models

@MainActor
final class SearchTests: XCTestCase {
    
    var store = TestStore(
        initialState: SearchFeature.State(),
        reducer: SearchFeature.init,
        withDependencies: {
            $0.mainQueue = .immediate
        }
    )
    
    func testOnInputChange() async {
        // Short search input
        await store.send(\.onInputChange, "H") { state in
            state.searchInput = "H"
        }
        
        // Valid search input
        await store.send(\.onInputChange, "Hello") { state in
            state.searchInput = "Hello"
            state.isLoading = true
        }
        
        await store.receive(\.searchMovies, "Hello")
        
        let searchResult = await store.dependencies.useCases.movies.search("Hello")
        guard case let .success(response) = searchResult else {
            XCTFail("Failed loading mock search result")
            return
        }
        
        await store.receive(\.searchResult, searchResult) { state in
            state.isLoading = false
            state.results = .init(uniqueElements: response.movies ?? [])
        }
        
        // Empty search input
        await store.send(\.onInputChange, "") { state in
            state.searchInput = ""
            state.isLoading = false
            state.results = []
        }
    }
    
    func testSearchMovies() async {
        // Genre tap
        let genreResult = await store.dependencies.useCases.movies.discoverByGenre(18)
        guard case let .success(response) = genreResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        await store.send(\.binding.isLoading, true) { $0.isLoading = true }
        await store.send(\.searchMovies, "Action")
        await store.receive(\.searchResult, genreResult) { state in
            state.isLoading = false
            state.results = .init(uniqueElements: response.movies ?? [])
        }
        
        // Free search
        let searchResult = await store.dependencies.useCases.movies.search("Test")
        guard case let .success(response) = searchResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        // Success result
        await store.send(\.binding.isLoading, true) { $0.isLoading = true }
        await store.send(\.searchMovies, "Test")
        await store.receive(\.searchResult, searchResult) { state in
            state.isLoading = false
            state.results = .init(uniqueElements: response.movies ?? [])
        }
        
        // Failure result
        await store.send(\.binding.isLoading, true) { $0.isLoading = true }
        await store.send(\.searchResult, .failure(.unknownError)) { state in
            state.isLoading = false
        }
    }
    
    // MARK: - View Actions
    
    func testOnGenreTap() async {
        // Invalid genre
        let noNameGenre = Genre(id: 0, name: nil)
        await store.send(.view(.onGenreTap(noNameGenre)))
        
        // Valid genre
        let genre = Genre.mock
        await store.send(\.view.onGenreTap, genre) { state in
            state.searchInput = genre.name ?? .empty
            state.isLoading = true
        }
        
        await store.receive(\.searchMovies, genre.name ?? .empty)
    }
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onMovieTap, mockMovie)
        await store.receive(\.navigation.presentMovie, mockMovie)
    }
    
    func testOnPreferencesTap() async {
        await store.send(\.view.onPreferencesTap)
        await store.receive(\.navigation.presentPreferences)
    }
    
    func testOnMovieLike() async {
        let mockMovie: Movie = .mock
        
        await store.send(.view(.onMovieLike(mockMovie))) { state in
            state.$watchlist.withLock { $0.append(mockMovie) }
        }
        
        await store.send(.view(.onMovieLike(mockMovie))) { state in
            let _ = state.$watchlist.withLock { $0.remove(mockMovie) }
        }
    }
}
