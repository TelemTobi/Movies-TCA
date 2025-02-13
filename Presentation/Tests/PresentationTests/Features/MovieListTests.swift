//
//  MovieListTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 29/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import MovieCollectionFeature
@testable import Models

@MainActor
final class MovieListTests: XCTestCase {
    
    var store = TestStore(
        initialState: MovieCollection.State(
            listType: .nowPlaying,
            movies: .init(uniqueElements: MovieList.mock.movies ?? [])
        ),
        reducer: MovieCollection.init
    )
    
    // MARK: - View Actions
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onMovieTap, mockMovie)
        await store.receive(\.navigation.presentMovie, mockMovie)
    }
    
    func testOnMovieLike() async {
        let mockMovie: Movie = .mock
        
        await store.send(.view(.onMovieLike(mockMovie)))
        await store.send(.view(.onMovieLike(mockMovie)))
    }
}
