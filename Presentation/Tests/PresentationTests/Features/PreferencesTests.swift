//
//  PreferencesTests.swift
//  Movies-TCA-Tests
//
//  Created by Telem Tobi on 30/03/2024.
//

import XCTest
import ComposableArchitecture
@testable import PreferencesFeature
@testable import Models

@MainActor
final class PreferencesTests: XCTestCase {
    
    var store = TestStore(
        initialState: PreferencesFeature.State(),
        reducer: PreferencesFeature.init
    )
    
    func testOnAdultContentToggle() async {
        await store.send(\.onAdultContentToggle, true) { state in
            state.$isAdultContentOn.withLock { $0 = true }
        }
    }
    
    func testOnAppearanceChange() async {
        await store.send(\.onAppearanceChange, "Dark") { state in
            state.$appearance.withLock { $0 = .dark }
        }
    }
    
    // MARK: - View Actions
    
    func testOnCloseButtonTap() async {
        await store.send(\.view.onCloseButtonTap)
    }
    
    func testOnLanguageTap() async {
        await store.send(\.view.onLanguageTap)
    }
}
