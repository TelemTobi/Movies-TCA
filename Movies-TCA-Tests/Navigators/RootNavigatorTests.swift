//
//  RootNavigatorTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 01/04/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class RootNavigatorTests: XCTestCase {
    
    var store = TestStore(
        initialState: RootNavigator.State(),
        reducer: RootNavigator.init
    )
    
    func testSplashCompleted() async {
        await store.send(\.destination.splash.navigation.splashCompleted) { state in
            state.destination = .home(HomeNavigator.State())
        }
    }
}
