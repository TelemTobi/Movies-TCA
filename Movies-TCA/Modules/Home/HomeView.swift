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
        NavigationStackStore(store.scope(state: \.path, action: { .path($0) })) {
            
            WithViewStore(store, observe: \.selectedTab) { viewStore in
                TabView(selection: viewStore.binding(send: HomeFeature.Action.onTabSelection)) {
                    
                    TabItemView(
                        type: .discover,
                        store: store.scope(
                            state: \.discoverTabItem,
                            action: { .discoverTabItem($0) }
                        )
                    )
                    .tabItem { Label("Discover", systemImage: "globe") }
                    .tag(HomeFeature.Tab.discover)
                    
                    TabItemView(
                        type: .search,
                        store: store.scope(
                            state: \.searchTabItem,
                            action: { .searchTabItem($0) }
                        )
                    )
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    .tag(HomeFeature.Tab.search)
                    
                    TabItemView(
                        type: .watchlist,
                        store: store.scope(
                            state: \.watchlistTabItem,
                            action: { .watchlistTabItem($0) }
                        )
                    )
                    .tabItem { Label("Watchlist", systemImage: "popcorn") }
                    .tag(HomeFeature.Tab.watchlist)
                }
                .toolbar(content: toolbarContent)
                .navigationTitle(viewStore.state.title)
                .onFirstAppear {
                    viewStore.send(.onFirstAppear)
                }
                .fullScreenCover(
                    store: store.scope(
                        state: \.$destination,
                        action: { .destination($0) }
                    ),
                    state: /HomeFeature.Destination.State.presentedMovie,
                    action: HomeFeature.Destination.Action.presentedMovie,
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
        } destination: { state in
            switch state {
            case .moviesList:
                CaseLet(
                    /HomeFeature.Path.State.moviesList,
                    action: HomeFeature.Path.Action.moviesList,
                    then: MoviesListView.init(store:)
                )
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                store.send(.onPreferencesTap)
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    @MainActor
    private func MovieSheet(store: StoreOf<MovieFeature>) -> some View {
        NavigationStack {
            MovieView(store: store)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close", systemImage: "xmark") {
                            store.send(.onCloseButtonTap)
                        }
                    }
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
