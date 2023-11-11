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
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView {
                Text("Home")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                Text("Search")
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                Text("Watchlist")
                    .tabItem {
                        Label("Watchlist", systemImage: "popcorn")
                    }
            }
            .onFirstAppear {
                store.send(.onFirstAppear)
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
