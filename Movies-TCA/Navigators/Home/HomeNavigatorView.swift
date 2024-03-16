//
//  HomeNavigatorView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 16/03/2024.
//

import SwiftUI
import ComposableArchitecture

extension HomeNavigator {
    
    struct ContentView: View {
        
        @Bindable var store: StoreOf<HomeNavigator>
        
        var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: { HomeView(store: store.scope(state: \.root, action: \.root)) },
                destination: { store in
                    
                }
            )
        }
    }
}

#Preview {
    HomeNavigator.ContentView(
        store: Store(
            initialState: HomeNavigator.State(),
            reducer: HomeNavigator.init
        )
    )
}

