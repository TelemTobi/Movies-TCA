//
//  MoviesApp.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture
import DesignSystem
import RootNavigator

@main
struct MoviesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootNavigator.ContentView(
                store: Store(
                    initialState: RootNavigator.State(),
                    reducer: RootNavigator.init
                )
            )
        }
    }
}
