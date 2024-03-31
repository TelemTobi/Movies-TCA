//
//  WatchlistTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 29/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class WatchlistTests: XCTestCase {
    
    var store = TestStore(
        initialState: WatchlistFeature.State(),
        reducer: WatchlistFeature.init
    )
    
    func testAlertDislikeAlert() async {
        let mockMovie = Movie.mock
        await store.send(.view(.onMovieDislike(mockMovie))) { state in
            state.alert = .dislikeConfirmation(for: mockMovie)
        }
        
        await store.send(.alert(.presented(.confirmDislike(mockMovie)))) { state in
            state.alert = nil
        }
        
        await store.receive(.view(.onMovieLike(mockMovie)))
    }
    
    // MARK: - View Actions
    
    func testSetLikedMovies() async {
        let likedMovies = [LikedMovie(.mock)]
        await store.send(.view(.setLikedMovies(likedMovies))) { state in
            state.likedMovies = .init(uniqueElements: likedMovies.map { $0.toMovie} )
        }
    }
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(.view(.onMovieTap(mockMovie)))
        await store.receive(.navigation(.presentMovie(mockMovie)))
    }
    
    func testOnPreferencesTap() async {
        await store.send(.view(.onPreferencesTap))
        await store.receive(.navigation(.presentPreferences))
    }
}
