//
//  DiscoveryTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 27/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import DiscoveryFeature
@testable import Models

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
    
    private func testMoviesFetching(ofType type: MovieListType) async {
        let result = await store.dependencies.useCases.movies.fetchList(type)
        
        guard case let .success(response) = result else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        await store.receive(.movieListResult(type, result)) { state in
            state.movies[type] = .init(uniqueElements: response.movies ?? [])
        }
    }

    func testMovieListLoaded() async {
        let nowPlayingResult = await store.dependencies.useCases.movies.fetchList(.nowPlaying)
        
        guard case let .success(response) = nowPlayingResult else {
            XCTFail("Failed loading mock movies")
            return
        }
        
        // Success Result
        await store.send(\.movieListResult, (.nowPlaying, nowPlayingResult)) { state in
            state.movies[.nowPlaying] = .init(uniqueElements: response.movies ?? [])
        }
        
        // Bad Response
        let invalidMovieList = MovieList(movies: nil, page: nil, totalPages: nil, totalResults: nil)
        await store.send(\.movieListResult, (.nowPlaying, .success(invalidMovieList)))
        await store.receive(.movieListResult(.nowPlaying, .failure(.unknownError)))
        
        // Failure Result
        await store.send(\.movieListResult, (.nowPlaying, .failure(.unknownError)))
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
    
    func testOnMovieListTap() async {
        let movieList = IdentifiedArrayOf<Movie>(uniqueElements: MovieList.mock.movies ?? [])
        await store.send(\.view.onMovieListTap, (.nowPlaying, movieList))
        await store.receive(.navigation(.pushMovieList(.nowPlaying, movieList)))
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
