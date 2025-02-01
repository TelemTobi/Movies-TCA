//
//  SplashTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 27/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import SplashFeature
@testable import Models

@MainActor
final class SplashTests: XCTestCase {

    var store = TestStore(
        initialState: SplashFeature.State(),
        reducer: SplashFeature.init
    )

    func testFetchGenres() async {
        // Success result
        let genresResult = await store.dependencies.useCases.genres.fetch()
        
        await store.send(\.fetchGenres)
        await store.receive(\.genresResult, genresResult)
        await store.receive(\.navigation.splashCompleted)
        
        // Failure result
        await store.send(\.genresResult, .failure(.unknownError))
    }
    
    // MARK: - View Actions
    
    func testOnAppear() async {
        await store.send(\.view.onAppear)
        await store.receive(\.fetchGenres)
    }
}
