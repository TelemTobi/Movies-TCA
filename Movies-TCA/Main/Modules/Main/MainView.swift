//
//  MainView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 06/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    
    let store: StoreOf<Main>
    
    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(send: Main.Action.onTabSelection)) {
                HomeView(
                    store: store.scope(
                        state: \.home,
                        action: Main.Action.home
                    )
                )
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Main.Tab.home)
                
                Text("Search")
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                    .tag(Main.Tab.search)
                
                Text("Watchlist")
                    .tabItem { Label("Watchlist", systemImage: "popcorn") }
                    .tag(Main.Tab.watchlist)
            }
            .onFirstAppear {
                store.send(.onFirstAppear)
            }
        }
    }
}

#Preview {
    MainView(
        store: .init(
            initialState: Main.State(),
            reducer: { Main() }
        )
    )
}
