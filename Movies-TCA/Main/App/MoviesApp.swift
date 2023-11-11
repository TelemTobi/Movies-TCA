//
//  MoviesApp.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI

@main
struct MoviesApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                store: .init(
                    initialState: Home.State(),
                    reducer: { Home()._printChanges() }
                )
            )
        }
    }
}
