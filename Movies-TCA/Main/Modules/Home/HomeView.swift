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
                        action: HomeFeature.Action.discover
                    )
                )
                .tabItem { Label("Discover", systemImage: "globe") }
                .tag(HomeFeature.Tab.discover)
                
                Text("Search")
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    .tag(HomeFeature.Tab.search)
                
                Text("Watchlist")
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
        store: .init(
            initialState: HomeFeature.State(),
            reducer: { HomeFeature() }
        )
    )
}
