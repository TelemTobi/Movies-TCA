//
//  DiscoveryTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 27/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class DiscoveryTests: XCTestCase {
    
    var store = TestStore(
        initialState: DiscoveryFeature.State(),
        reducer: { DiscoveryFeature() }
    )
    
    func testLoadMovies() async { // TODO: Figure out how to test properly
        store.exhaustivity = .off
        await store.send(.loadMovies)
        
        await store.receive(\.moviesListLoaded)
        await store.receive(\.moviesListLoaded)
        await store.receive(\.moviesListLoaded)
        await store.receive(\.moviesListLoaded)
        await store.receive(\.loadingCompleted)
        store.exhaustivity = .on
    }

    func testMoviesListLoaded() async {
        // Success Response
        let nowPlayingResult = await store.dependencies.tmdbClient.fetchMovies(.nowPlaying)
        
        await store.send(.moviesListLoaded(.nowPlaying, nowPlayingResult)) { state in
            guard case let .success(response) = nowPlayingResult else {
                XCTFail("Failed loading mock movies")
                return
            }
            
            state.movies[.nowPlaying] = .init(uniqueElements: response.results ?? [])
        }
        
        // Null Response
        let invalidMovieList = MoviesList(results: nil, page: nil, totalPages: nil, totalResults: nil)
        await store.send(.moviesListLoaded(.nowPlaying, .success(invalidMovieList)))
        await store.receive(\.moviesListLoaded)
    }
    
    func testLoadingCompleted() async {
        await store.send(.loadingCompleted) { state in
            state.isLoading = false
        }
        
        await store.receive(\.setLikedMovies)
    }
    
    // MARK: - View Actions
    
    func testOnFirstAppear() async {
        await store.send(.view(.onFirstAppear))
        await store.receive(\.loadMovies)
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
    
    func testOnMoviesListTap() async {
        let moviesList = IdentifiedArrayOf<Movie>(uniqueElements: MoviesList.mock.results ?? [])
        await store.send(.view(.onMoviesListTap(.nowPlaying, moviesList)))
        await store.receive(.navigation(.pushMoviesList(.nowPlaying, moviesList)))
    }
}
