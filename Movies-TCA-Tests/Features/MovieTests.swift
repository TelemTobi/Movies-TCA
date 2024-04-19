//
//  MovieTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 30/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class MovieTests: XCTestCase {
    
    var store = TestStore(
        initialState: MovieFeature.State(movieDetails: .init(movie: .mock)),
        reducer: MovieFeature.init
    )
    
    func testLoadExtendedDetails() async throws {
        let movieId = try XCTUnwrap(store.state.movieDetails.movie.id)
        let movieDetailsResult = await store.dependencies.tmdbClient.movieDetails(movieId)

        guard case let .success(response) = movieDetailsResult else {
            XCTFail("Failed loading mock movie details")
            return
        }
        
        await store.send(.loadExtendedDetails)
        
        // Success result
        await store.receive(.movieDetailsLoaded(movieDetailsResult)) { state in
            state.movieDetails = response
        }
        
        // Failure result
        await store.send(.movieDetailsLoaded(.unknownError))
    }
    
    // MARK: - View Actions
    
    func testOnFirstAppear() async {
        await store.send(.view(.onFirstAppear))
        await store.receive(\.loadExtendedDetails)
    }
    
    func testOnCloseButtonTap() async {
        await store.send(.view(.onCloseButtonTap))
        await store.receive(.navigation(.dismissFlow))
    }
    
    func testOnRelatedMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(.view(.onRelatedMovieTap(mockMovie)))
        await store.receive(.navigation(.pushRelatedMovie(mockMovie)))
    }
    
    func testOnLikeTap() async {
        let mockMovie = Movie.mock
//        await store.send(.view(.onLikeTap(mockMovie)))
    }
}
