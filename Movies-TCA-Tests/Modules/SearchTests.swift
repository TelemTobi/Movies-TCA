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
    
    // MARK: - View Actions
}
