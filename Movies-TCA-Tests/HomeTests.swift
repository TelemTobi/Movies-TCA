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
}
