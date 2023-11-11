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
            MainView(
                store: .init(
                    initialState: Main.State(),
                    reducer: { Main() }
                )
            )
        }
    }
}
