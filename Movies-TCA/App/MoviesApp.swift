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
    
    var modelContext: ModelContext {
        guard let modelContext = try? self.database.getContext() else {
            fatalError("Could not find modelContext")
        }
        return modelContext
    }
    
    var body: some Scene {
        WindowGroup {
            RootNavigator.ContentView(
                store: Store(
                    initialState: RootNavigator.State(),
                    reducer: RootNavigator.init
                )
            )
            .modelContext(modelContext)
            .adjustPreferredColorScheme()
            .onFirstAppear {
                Preferences.Appearance.systemColorScheme = colorScheme
            }
        }
    }
}
