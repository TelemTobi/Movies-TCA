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
    
    var modelContext: ModelContext {
        guard let modelContext = try? self.database.context() else {
            fatalError("Could not find modelContext")
        }
        return modelContext
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: RootFeature.State(),
                    reducer: { RootFeature() }
                )
            )
            .modelContext(modelContext)
        }
    }
}
