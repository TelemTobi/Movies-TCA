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
        
        @Namespace var transitionNamespace
        
        public init(store: StoreOf<HomeNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            TabView(selection: $store.selectedTab.sending(\.onTabSelection)) {
                DiscoveryNavigator.ContentView(
                    store: store.scope(state: \.discover, action: \.discover)
                )
                .tabItem { Label(.localized(.discovery), systemImage: "globe") }
                .tag(HomeNavigator.Tab.discovery)
                
                SearchNavigator.ContentView(
                    store: store.scope(state: \.search, action: \.search)
                )
                .tabItem { Label(.localized(.search), systemImage: "magnifyingglass") }
                .tag(HomeNavigator.Tab.search)
                
                WatchlistNavigator.ContentView(
                    store: store.scope(state: \.watchlist, action: \.watchlist)
                )
                .tabItem { Label(.localized(.watchlist), systemImage: "popcorn") }
                .tag(HomeNavigator.Tab.watchlist)
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

