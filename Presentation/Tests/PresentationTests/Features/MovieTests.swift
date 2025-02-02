//
//  MovieTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 30/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import MovieDetailsFeature
@testable import Models

@MainActor
final class MovieTests: XCTestCase {
    
    var store = TestStore(
        initialState: MovieDetails.State(detailedMovie: .init(movie: .mock)),
        reducer: MovieDetails.init
    )
    
    func testLoadExtendedDetails() async throws {
        let movieId = try XCTUnwrap(store.state.detailedMovie.movie.id)
        let movieDetailsResult = await store.dependencies.useCases.movie.fetchDetails(movieId)

        guard case let .success(response) = movieDetailsResult else {
            XCTFail("Failed loading mock movie details")
            return
        }
        
        await store.send(\.fetchMovieDetails)
        
        // Success result
        await store.receive(\.movieDetailsResult, movieDetailsResult) { state in
            state.movieDetails = response
        }
        
        // Failure result
        await store.send(\.movieDetailsResult, .failure(.unknownError))
    }
    
    // MARK: - View Actions
    
    func testOnFirstAppear() async {
        await store.send(\.view.onFirstAppear)
        await store.receive(\.fetchMovieDetails)
    }
    
    func testOnCloseButtonTap() async {
        await store.send(\.view.onCloseButtonTap)
        await store.receive(.navigation(.dismissFlow))
    }
    
    func testOnRelatedMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onRelatedMovieTap, mockMovie)
        await store.receive(\.navigation.pushRelatedMovie, mockMovie)
    }
    
    func testOnLikeTap() async {
        await store.send(.view(.onLikeTap))
        await store.send(.view(.onLikeTap))
    }
}
