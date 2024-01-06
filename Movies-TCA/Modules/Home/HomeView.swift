//
//  HomeView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(send: HomeFeature.Action.onTabSelection)) {
                
                DiscoverView(
                    store: store.scope(
                        state: \.discover,
                        action: { .discover($0) }
                    )
                )
                .tabItem { Label("Discover", systemImage: "globe") }
                .tag(HomeFeature.Tab.discover)
                
                SearchView(
                    store: store.scope(
                        state: \.search,
                        action: { .search($0) }
                    )
                )
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(HomeFeature.Tab.search)
                
                WatchlistView(
                    store: store.scope(
                        state: \.watchlist,
                        action: { .watchlist($0) }
                    )
                )
                .tabItem { Label("Watchlist", systemImage: "popcorn") }
                .tag(HomeFeature.Tab.watchlist)
            }
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
            .fullScreenCover(
                store: store.scope(
                    state: \.$destination,
                    action: { .destination($0) }
                ),
                state: /HomeFeature.Destination.State.movie,
                action: HomeFeature.Destination.Action.movie,
                content: { movieStore in
                    MovieSheet(store: movieStore)
                }
            )
            .sheet(
                store: store.scope(
                    state: \.$destination,
                    action: { .destination($0) }
                ),
                state: /HomeFeature.Destination.State.preferences,
                action: HomeFeature.Destination.Action.preferences,
                content: { preferencesStore in
                    PreferencesSheet(store: preferencesStore)
                }
            )
        }
    }
    
    @MainActor
    private func MovieSheet(store: StoreOf<MovieFeature>) -> some View {
        NavigationStackStore(self.store.scope(state: \.moviePath, action: { .moviePath($0) })) {
            MovieView(store: store)
        } destination: { state in
            switch state {
            case .relatedMovie:
                CaseLet(
                    /HomeFeature.MoviePath.State.relatedMovie,
                    action: HomeFeature.MoviePath.Action.relatedMovie,
                    then: MovieView.init(store:)
                )
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
                            store.send(.onCloseButtonTap)
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
