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
        reducer: DiscoveryFeature.init
    )
    
    func testLoadMovies() async { // TODO: Figure out how to test properly
        await store.send(.loadMovies)
        
        await testMoviesFetching(ofType: .nowPlaying)
        await testMoviesFetching(ofType: .popular)
        await testMoviesFetching(ofType: .upcoming)
        await testMoviesFetching(ofType: .topRated)
        
        await store.receive(\.loadingCompleted) { state in
            state.isLoading = false
        }
    }
    
    private func testMoviesFetching(ofType type: MoviesListType) async {
        let result = await store.dependencies.tmdbClient.fetchMovies(type)
        
        guard case let .success(response) = result else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        await store.receive(.moviesListLoaded(type, result)) { state in
            state.movies[type] = .init(uniqueElements: response.results ?? [])
        }
    }

    func testMoviesListLoaded() async {
        let nowPlayingResult = await store.dependencies.tmdbClient.fetchMovies(.nowPlaying)
        
        guard case let .success(response) = nowPlayingResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        // Success Result
        await store.send(\.moviesListLoaded, (.nowPlaying, nowPlayingResult)) { state in
            state.movies[.nowPlaying] = .init(uniqueElements: response.results ?? [])
        }
        
        // Bad Response
        let invalidMovieList = MoviesList(results: nil, page: nil, totalPages: nil, totalResults: nil)
        await store.send(\.moviesListLoaded, (.nowPlaying, .success(invalidMovieList)))
        await store.receive(.moviesListLoaded(.nowPlaying, .unknownError))
        
        // Failure Result
        await store.send(\.moviesListLoaded, (.nowPlaying, .unknownError))
    }
    
    func testLoadingCompleted() async {
        await store.send(\.loadingCompleted) { state in
            state.isLoading = false
        }
    }
    
    // MARK: - View Actions
    
    func testOnFirstAppear() async {
        await store.send(\.view.onFirstAppear)
        await store.receive(\.loadMovies)
    }
    
    func testOnMovieTap() async {
        let mockMovie = Movie.mock
        await store.send(\.view.onMovieTap, mockMovie)
        await store.receive(\.navigation.presentMovie, mockMovie)
    }
    
    func testOnPreferencesTap() async {
        await store.send(\.view.onPreferencesTap)
        await store.receive(\.navigation.presentPreferences)
    }
    
    func testOnMoviesListTap() async {
        let moviesList = IdentifiedArrayOf<Movie>(uniqueElements: MoviesList.mock.results ?? [])
        await store.send(\.view.onMoviesListTap, (.nowPlaying, moviesList))
        await store.receive(.navigation(.pushMoviesList(.nowPlaying, moviesList)))
    }
    
    func testOnMovieLike() async {
        let mockMovie: Movie = .mock
        
        await store.send(.view(.onMovieLike(mockMovie))) { state in
            state.likedMovies.append(mockMovie)
        }
        
        await store.send(.view(.onMovieLike(mockMovie))) { state in
            state.likedMovies.remove(mockMovie)
        }
    }
}
