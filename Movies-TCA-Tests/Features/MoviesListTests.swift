//
//  MoviesListTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 29/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class MoviesListTests: XCTestCase {
    
    var store = TestStore(
        initialState: MoviesListFeature.State(
            listType: .nowPlaying,
            movies: .init(uniqueElements: MoviesList.mock.results ?? [])
        ),
        reducer: MoviesListFeature.init
    )
    
    // MARK: - View Actions
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onMovieTap, mockMovie)
        await store.receive(\.navigation.presentMovie, mockMovie)
    }
}
