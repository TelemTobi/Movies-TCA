//
//  MoviesApp.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct MoviesApp: App {
    
    @Dependency(\.database) var database
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            RootNavigator.ContentView(
                store: Store(
                    initialState: RootNavigator.State(),
                    reducer: RootNavigator.init
                )
            )
            .modelContext(database.getContext())
            .adjustPreferredColorScheme()
            .onFirstAppear {
                Preferences.Appearance.systemColorScheme = colorScheme
            }
        }
    }
}
