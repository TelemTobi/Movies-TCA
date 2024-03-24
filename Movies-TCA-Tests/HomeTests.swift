//
//  HomeTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 30/12/2023.
//

import XCTest
import ComposableArchitecture
@testable import Movies_TCA

@MainActor
final class HomeTests: XCTestCase {

    var store: TestStoreOf<HomeFeature>!
    
    override func setUpWithError() throws {
        store = TestStore(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        )
    }

    override func tearDownWithError() throws {
        store = nil
    }
    
    func testStoreInit() {
        XCTAssertEqual(store.state.selectedTab, .discover)
    }
    
    func testTabSelection() async {
        await store.send(.onTabSelection(.search)) {
            $0.selectedTab = .search
        }
        
        await store.send(.onTabSelection(.discover)) {
            $0.selectedTab = .discover
        }
        
        await store.send(.onTabSelection(.watchlist)) {
            $0.selectedTab = .watchlist
        }
    }
    
    func testSetGenres() async {
        let genres = IdentifiedArray(uniqueElements: GenresResponse.mock.genres ?? [])
        
        await store.send(.setGenres(genres)) {
            $0.search.genres = genres
        }
    }
    
    func testOnPreferencesTap() async {
        await store.send(.discover(.onPreferencesTap)) {
            $0.destination = .preferences(PreferencesFeature.State())
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
        
        await store.send(.search(.onPreferencesTap)) {
            $0.destination = .preferences(PreferencesFeature.State())
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
        
        await store.send(.watchlist(.onPreferencesTap)) {
            $0.destination = .preferences(PreferencesFeature.State())
        }
    }
    
    func testOnMovieTap() async {
        let movie = Movie.mock
        
        // Discovery Feature
        await store.send(.discover(.onMovieTap(movie))) {
            $0.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
        
        // Search Feature
        await store.send(.search(.onMovieTap(movie))) {
            $0.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
        
        // Watchlist Feature
        await store.send(.watchlist(.onMovieTap(movie))) {
            $0.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
        }
    }
    
    func testOnRelatedMovieTap() async {
        let movie = Movie.mock
        
        await store.send(.discover(.onMovieTap(movie))) {
            $0.destination = .movie(MovieFeature.State(movieDetails: .init(movie: movie)))
        }
        
        let relatedMovie = Movie.mock
        
        await store.send(.destination(.presented(.movie(.onRelatedMovieTap(relatedMovie))))) {
            $0.moviePath[id: 0] = .relatedMovie(MovieFeature.State(movieDetails: .init(movie: relatedMovie)))
        }
    }
}
