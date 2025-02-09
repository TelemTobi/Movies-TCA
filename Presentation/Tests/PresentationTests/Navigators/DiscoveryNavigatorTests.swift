//
//  DiscoveryNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
import ComposableArchitecture
@testable import DiscoveryNavigator
@testable import MovieCollectionFeature
@testable import PreferencesFeature
@testable import MovieNavigator
@testable import Models

@MainActor
final class DiscoveryNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: DiscoveryNavigator.State(),
        reducer: DiscoveryNavigator.init
    )
    
    func testPushMovieList() async {
        let mockMovieList: IdentifiedArrayOf<Movie> = .init(uniqueElements: [Movie.mock])
        
        await store.send(\.root.navigation.pushMovieList, (.nowPlaying, mockMovieList)) { state in
            state.path.append(.movieList(MovieCollection.State(listType: .nowPlaying, movies: mockMovieList)))
        }
        
        await store.send(\.path.popFrom, 0) { state in
            state.path.removeLast()
        }
    }
    
    func testPresentMovie() async {
        let mockMovie = Movie.mock
        
        await store.send(\.root.navigation.presentMovie, mockMovie) { state in
            state.destination = .movie(MovieNavigator.State(detailedMovie: .init(movie: mockMovie)))
        }
        
        await store.send(\.destination.dismiss) { state in
            state.destination = nil
        }
        
        let mockMovieList: IdentifiedArrayOf<Movie> = .init(uniqueElements: [Movie.mock])
        await store.send(\.root.navigation.pushMovieList, (.nowPlaying, mockMovieList)) { state in
            state.path.append(.movieList(MovieCollection.State(listType: .nowPlaying, movies: mockMovieList)))
        }
        
        await store.send(\.path[id: 0].movieList.navigation.presentMovie, mockMovie) { state in
            state.destination = .movie(MovieNavigator.State(detailedMovie: .init(movie: mockMovie)))
        }
        
        await store.send(\.destination.dismiss) { state in
            state.destination = nil
        }
        
        await store.send(\.path.popFrom, 0) { state in
            state.path.removeLast()
        }
    }
    
    func testPresentPreferences() async {
        await store.send(\.root.navigation.presentPreferences) { state in
            state.destination = .preferences(Preferences.State())
        }
    }
}
