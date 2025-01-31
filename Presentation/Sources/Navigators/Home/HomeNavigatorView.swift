//
//  HomeNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 16/03/2024.
//

import SwiftUI
import ComposableArchitecture
import DiscoveryNavigator
import SearchNavigator
import WatchlistNavigator

public extension HomeNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<HomeNavigator>
        
        public init(store: StoreOf<HomeNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            TabView(selection: $store.selectedTab.sending(\.onTabSelection)) {
                DiscoveryNavigator.ContentView(
                    store: store.scope(state: \.discover, action: \.discover)
                )
                .tabItem { Label("Discovery", systemImage: "globe") }
                .tag(HomeNavigator.Tab.discover)
                
                SearchNavigator.ContentView(
                    store: store.scope(state: \.search, action: \.search)
                )
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(HomeNavigator.Tab.search)
                
                WatchlistNavigator.ContentView(
                    store: store.scope(state: \.watchlist, action: \.watchlist)
                )
                .tabItem { Label("Watchlist", systemImage: "popcorn") }
                .tag(HomeNavigator.Tab.watchlist)
            }
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

