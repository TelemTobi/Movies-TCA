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
        
        @Bindable var store: StoreOf<RootNavigator>
        
        var body: some View {
            Group {
                switch store.scope(state: \.destination, action: \.destination).case {
                case .splash:
                    SplashView()
                    
                case let .home(store):
                    HomeView(store: store)
                }
            }
            .animation(.easeInOut, value: store.destination)
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
