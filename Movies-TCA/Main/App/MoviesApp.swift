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
    
    let store = Store(
        initialState: AppReducer.State(),
        reducer: { AppReducer() }
    )
    
    var body: some Scene {
        WindowGroup {
            WithViewStore(store, observe: \.isLoading) { viewStore in
                Group {
                    if viewStore.state {
                        SplashView()
                            .onFirstAppear {
                                viewStore.send(.onFirstAppear)
                            }
                    } else {
                        HomeView(
                            store: store.scope(
                                state: \.home,
                                action: AppReducer.Action.home
                            )
                        )
                    }
                }
                .animation(.easeInOut, value: viewStore.state)
            }
        }
    }
}
