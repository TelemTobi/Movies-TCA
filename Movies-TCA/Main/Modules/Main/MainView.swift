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
    MainView(
        store: .init(
            initialState: Main.State(),
            reducer: { Main() }
        )
    )
}
