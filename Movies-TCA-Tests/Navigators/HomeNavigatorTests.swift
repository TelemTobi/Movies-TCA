//
//  HomeNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class HomeNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: HomeNavigator.State(),
        reducer: HomeNavigator.init
    )
    
    func testOnTabSelection() async {
        await store.send(\.onTabSelection, .search) { state in
            state.selectedTab = .search
        }
        
        await store.send(\.onTabSelection, .watchlist) { state in
            state.selectedTab = .watchlist
        }
    }
}
