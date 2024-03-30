//
//  PreferencesTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 30/03/2024.
//

import XCTest
@testable import Movies_TCA
import ComposableArchitecture

@MainActor
final class PreferencesTests: XCTestCase {
    
    var store = TestStore(
        initialState: PreferencesFeature.State(),
        reducer: PreferencesFeature.init
    )
    
    func testOnAdultContentToggle() async {
        await store.send(.onAdultContentToggle(true)) { state in
            state.isAdultContentOn = true
        }
    }
    
    func testOnAppearanceChange() async {
        await store.send(.onAppearanceChange("Dark")) { state in
            state.appearance = "Dark"
        }
    }
    
    // MARK: - View Actions
    
    func testOnCloseButtonTap() async {
        await store.send(.view(.onCloseButtonTap))
    }
    
    func testOnLanguageTap() async {
        await store.send(.view(.onLanguageTap))
    }
}
