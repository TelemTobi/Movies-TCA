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
                
                TabItemView(
                    type: .discover,
                    store: store.scope(
                        state: \.tabItem,
                        action: { .tabItem($0) }
                    )
                )
                .tabItem { Label("Discover", systemImage: "globe") }
                .tag(HomeFeature.Tab.discover)
                
                TabItemView(
                    type: .search,
                    store: store.scope(
                        state: \.tabItem,
                        action: { .tabItem($0) }
                    )
                )
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(HomeFeature.Tab.search)
                
                TabItemView(
                    type: .watchlist,
                    store: store.scope(
                        state: \.tabItem,
                        action: { .tabItem($0) }
                    )
                )
                .tabItem { Label("Watchlist", systemImage: "popcorn") }
                .tag(HomeFeature.Tab.watchlist)
            }
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
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
