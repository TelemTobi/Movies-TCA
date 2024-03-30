//
//  SplashTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 27/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class SplashTests: XCTestCase {

    var store = TestStore(
        initialState: SplashFeature.State(),
        reducer: SplashFeature.init
    )

    func testLoadGenres() async {
        // Successful response
        let response = await store.dependencies.tmdbClient.fetchGenres()
        
        await store.send(.loadGenres)
        await store.receive(\.genresResponse, response)
        await store.receive(.navigation(.splashCompleted)) // TODO
        
        // TODO: Make sure genres are saved to the shared state
        
        // Bad response
        store.dependencies.tmdbClient.fetchGenres = {
            .success(GenresResponse(genres: nil))
        }
        
        await store.send(.loadGenres)
        await store.receive(\.genresResponse)
        await store.receive(\.genresResponse, .unknownError)
    }
    
    // MARK: - View Actions
    
    func testOnAppear() async {
        await store.send(.view(.onAppear))
        await store.receive(\.loadGenres)
    }
}
