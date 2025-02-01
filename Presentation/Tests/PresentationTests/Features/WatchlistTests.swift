//
//  WatchlistTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 29/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import WatchlistFeature
@testable import Models

@MainActor
final class WatchlistTests: XCTestCase {
    
    var store = TestStore(
        initialState: WatchlistFeature.State(),
        reducer: WatchlistFeature.init
    )
    
    func testDislikeAlert() async {
        let mockMovie = Movie.mock
        await store.send(.view(.onMovieDislike(mockMovie))) { state in
            state.alert = .dislikeConfirmation(for: mockMovie)
        }
        
        await store.send(\.alert.presented.confirmDislike, mockMovie) { state in
            state.alert = nil
            let _ = state.$watchlist.withLock { $0.remove(mockMovie) }
        }
    }
    
    // MARK: - View Actions
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onMovieTap, mockMovie)
        await store.receive(\.navigation.presentMovie, mockMovie)
    }
    
    func testOnPreferencesTap() async {
        await store.send(\.view.onPreferencesTap)
        await store.receive(\.navigation.presentPreferences)
    }
}
