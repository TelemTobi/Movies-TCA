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
            TabView(selection: $store.selectedTab.sending(\.onTabSelection)) {
                DiscoverView(
                    store: store.scope(state: \.discover, action: \.discover)
                )
                .tabItem { Label("Discovery", systemImage: "globe") }
                .tag(HomeNavigator.Tab.discover)
                
                SearchView(
                    store: store.scope(state: \.search, action: \.search)
                )
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(HomeNavigator.Tab.search)
                
                WatchlistView(
                    store: store.scope(state: \.watchlist, action: \.watchlist)
                )
                .tabItem { Label("Watchlist", systemImage: "popcorn") }
                .tag(HomeNavigator.Tab.watchlist)
            }
            .fullScreenCover(
                item: $store.scope(state: \.destination, action: \.destination), 
                content: { store in
                    switch store.case {
                    case let .movie(store):
                        MovieSheet(store: store)
                        
                    case let .preferences(store):
                        PreferencesSheet(store: store)
                    }
                }
            )
        }
        
        @MainActor
        private func MovieSheet(store: StoreOf<MovieFeature>) -> some View {
            NavigationStack {
                //        NavigationStack(path: $store.scope(state: \.moviePath, action: \.moviePath)) {
                MovieView(store: store)
                //        } destination: { store in
                //            switch store.case {
                //            case let .relatedMovie(store):
                //                MovieView(store: store)
                //            }
                //        }
            }
        }
        
        @MainActor
        private func PreferencesSheet(store: StoreOf<PreferencesFeature>) -> some View {
            NavigationStack {
                PreferencesView(store: store)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Close", systemImage: "xmark") {
                                store.send(.view(.onCloseButtonTap))
                            }
                        }
                    }
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

