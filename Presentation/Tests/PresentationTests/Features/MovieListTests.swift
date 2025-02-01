//
//  MovieListTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 29/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import MovieListFeature
@testable import Models

@MainActor
final class MovieListTests: XCTestCase {
    
    var store = TestStore(
        initialState: MovieListFeature.State(
            listType: .nowPlaying,
            movies: .init(uniqueElements: MovieList.mock.movies ?? [])
        ),
        reducer: MovieListFeature.init
    )
    
    // MARK: - View Actions
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onMovieTap, mockMovie)
        await store.receive(\.navigation.presentMovie, mockMovie)
    }
    
    func testOnMovieLike() async {
        let mockMovie: Movie = .mock
        
        await store.send(.view(.onMovieLike(mockMovie))) { state in
            state.$watchlist.withLock { $0.append(mockMovie) }
        }
        
        await store.send(.view(.onMovieLike(mockMovie))) { state in
            let _ = state.$watchlist.withLock { $0.remove(mockMovie) }
        }
    }
}
