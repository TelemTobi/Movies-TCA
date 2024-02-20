//
//  HomeView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HomeFeature.self)
struct HomeView: View {
    
    @Bindable var store: StoreOf<HomeFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.onTabSelection)) {
            
            DiscoverView(
                store: store.scope(state: \.discover, action: \.discover)
            )
            .tabItem { Label("Discovery", systemImage: "globe") }
            .tag(HomeFeature.Tab.discover)
            
            SearchView(
                store: store.scope(state: \.search, action: \.search)
            )
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(HomeFeature.Tab.search)
            
            WatchlistView(
                store: store.scope(state: \.watchlist, action: \.watchlist)
            )
            .tabItem { Label("Watchlist", systemImage: "popcorn") }
            .tag(HomeFeature.Tab.watchlist)
        }
        .fullScreenCover(
            item: $store.scope(
                state: \.destination?.movie,
                action: \.destination.movie
            ),
            content: { store in
                MovieSheet(store: store)
            }
        )
        .sheet(
            item: $store.scope(
                state: \.destination?.preferences,
                action: \.destination.preferences
            ),
            content: { store in
                PreferencesSheet(store: store)
            }
        )
    }
    
    @MainActor
    private func MovieSheet(store: StoreOf<MovieFeature>) -> some View {
        NavigationStack(path: $store.scope(state: \.moviePath, action: \.moviePath)) {
            MovieView(store: store)
        } destination: { store in
            switch store.case {
            case let .relatedMovie(store):
                MovieView(store: store)
            }
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

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        )
    )
}
