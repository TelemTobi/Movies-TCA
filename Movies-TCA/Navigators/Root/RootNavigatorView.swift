//
//  RootNavigatorView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/03/2024.
//

import SwiftUI
import ComposableArchitecture

extension RootNavigator {
    
    struct ContentView: View {
        
        let store: StoreOf<RootNavigator>
        
        var body: some View {
            Group {
                switch store.destination {
                case .splash:
                    if let store = store.scope(state: \.destination.splash, action: \.destination.splash) {
                        SplashView(store: store)
                    }
                    
                    
                case .home:
                    if let store = store.scope(state: \.destination.home, action: \.destination.home) {
                        HomeNavigator.ContentView(store: store)
                    }
                }
            }
            .animation(.easeInOut, value: store.destination)
            .adjustPreferredAppearance()
        }
    }
}

#Preview {
    RootNavigator.ContentView(
        store: Store(
            initialState: RootNavigator.State(),
            reducer: RootNavigator.init
        )
    )
}
