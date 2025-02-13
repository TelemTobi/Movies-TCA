//
//  HomeNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 16/03/2024.
//

import SwiftUI
import ComposableArchitecture
import MoviesNavigator
import SearchNavigator

public extension HomeNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<HomeNavigator>
        
        @Namespace var transitionNamespace
        
        public init(store: StoreOf<HomeNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            TabView(selection: $store.selectedTab.sending(\.onTabSelection)) {
                MoviesNavigator.ContentView(
                    store: store.scope(state: \.movies, action: \.movies)
                )
                .tabItem { Label(.localized(.movies), systemImage: "movieclapper") }
                .tag(HomeNavigator.Tab.movies)
                
                SearchNavigator.ContentView(
                    store: store.scope(state: \.search, action: \.search)
                )
                .tabItem { Label(.localized(.search), systemImage: "magnifyingglass") }
                .tag(HomeNavigator.Tab.search)
            }
            .environment(\.namespace, transitionNamespace)
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

