//
//  SearchNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
import ComposableArchitecture
@testable import SearchNavigator
@testable import MovieNavigator
@testable import PreferencesFeature
@testable import Models

@MainActor
final class SearchNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: SearchNavigator.State(),
        reducer: SearchNavigator.init
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
