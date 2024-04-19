//
//  MovieNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class MovieNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: MovieNavigator.State(movieDetails: .init(movie: .mock)),
        reducer: MovieNavigator.init
    )
    
    func testPushRelatedMovie() async {
        let mockMovie = Movie.mock
        
        await store.send(\.root.navigation.pushRelatedMovie, mockMovie) { state in
            state.path.append(.relatedMovie(MovieFeature.State(movieDetails: .init(movie: mockMovie))))
        }
        
        await store.send(\.path[id: 0].relatedMovie.navigation.pushRelatedMovie, mockMovie) { state in
            state.path.append(.relatedMovie(MovieFeature.State(movieDetails: .init(movie: mockMovie))))
        }
        
        await store.send(\.path[id: 1].relatedMovie.navigation.dismissFlow)
    }
    
    func testDismissFlow() async {
        await store.send(\.root.navigation.dismissFlow)
    }
}
