//
//  MoviesApp.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct MoviesApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: RootFeature.State(),
                    reducer: { RootFeature() }
                )
            )
        }
    }
}
