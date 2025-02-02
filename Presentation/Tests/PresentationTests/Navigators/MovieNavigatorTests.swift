//
//  MovieNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
import ComposableArchitecture
@testable import MovieNavigator
@testable import MovieDetailsFeature
@testable import Models

@MainActor
final class MovieNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: MovieNavigator.State(detailedMovie: .init(movie: .mock)),
        reducer: MovieNavigator.init
    )
    
    func testPushRelatedMovie() async {
        let mockMovie = Movie.mock
        
        await store.send(\.root.navigation.pushRelatedMovie, mockMovie) { state in
            state.path.append(.relatedMovie(MovieDetails.State(detailedMovie: .init(movie: mockMovie))))
        }
        
        await store.send(\.path[id: 0].relatedMovie.navigation.pushRelatedMovie, mockMovie) { state in
            state.path.append(.relatedMovie(MovieDetails.State(detailedMovie: .init(movie: mockMovie))))
        }
        
        await store.send(\.path[id: 1].relatedMovie.navigation.dismissFlow)
    }
    
    func testDismissFlow() async {
        await store.send(\.root.navigation.dismissFlow)
    }
}
