//
//  HomeView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    
    let store: StoreOf<Home>
    
    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(send: Home.Action.onTabSelection)) {
                DiscoverView(
                    store: store.scope(
                        state: \.discover,
                        action: Home.Action.discover
                    )
                )
                .tabItem { Label("Discover", systemImage: "globe") }
                .tag(Home.Tab.discover)
                
                Text("Search")
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    .tag(Home.Tab.search)
                
                Text("Watchlist")
                    .tabItem { Label("Watchlist", systemImage: "popcorn") }
                    .tag(Home.Tab.watchlist)
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
            initialState: Home.State(),
            reducer: { Home() }
        )
    )
}
