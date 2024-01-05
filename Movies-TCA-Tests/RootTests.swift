//
//  RootTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 29/12/2023.
//

import XCTest
import ComposableArchitecture
@testable import Movies_TCA

@MainActor
final class RootTests: XCTestCase {

    var store: TestStoreOf<RootFeature>!
    
    override func setUpWithError() throws {
        store = TestStore(
            initialState: RootFeature.State(),
            reducer: { RootFeature() },
            withDependencies: { $0.tmdbClient = .testValue }
        )
    }

    override func tearDownWithError() throws {
        store = nil
    }

    func testStoreInit() {
        XCTAssertTrue(store.state.isLoading)
    }
    
    func testLoadGenres() async {
        // TODO: ⚠️
    }
    
    func testSuccessGenresResponse() async {
        let mockResponse = GenresResponse.mock
        
        await store.send(.genresResponse(.success(mockResponse))) { state in
            state.isLoading = false
        }
        
        let genres = IdentifiedArray(uniqueElements: mockResponse.genres ?? [])
        
        await store.receive(.home(.setGenres(genres))) {
            $0.home.search.genres = genres
        }
    }
    
    func testFailureGenresResponse() async {
        // Test failure
        await store.send(.genresResponse(.failure(.init(.unknownError)))) { state in
            state.isLoading = false
        }
        
        // Test bad success result
        await store.send(.genresResponse(.success(.init(genres: nil))))
        await store.receive(.genresResponse(.failure(.init(.unknownError))))
    }
}
