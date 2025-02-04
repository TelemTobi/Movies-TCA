//
//  WatchlistNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
import ComposableArchitecture
@testable import WatchlistNavigator
@testable import MovieNavigator
@testable import PreferencesFeature
@testable import Models

@MainActor
final class WatchlistNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: WatchlistNavigator.State(),
        reducer: WatchlistNavigator.init
    )
    
    func testPresentMovie() async {
        let mockMovie = Movie.mock
        
        await store.send(\.root.navigation.presentMovie, mockMovie) { state in
            state.destination = .movie(MovieNavigator.State(detailedMovie: .init(movie: mockMovie)))
        }
        
        await store.send(\.destination.dismiss) { state in
            state.destination = nil
        }
    }
    
    func testPresentPreferences() async {
        await store.send(\.root.navigation.presentPreferences) { state in
            state.destination = .preferences(Preferences.State())
        }
    }
}

