//
//  HomeNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 16/03/2024.
//

import SwiftUI
import ComposableArchitecture
import MoviesNavigator
import SearchNavigator

public extension HomeNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<HomeNavigator>
        
        @Namespace var transitionNamespace
        
        public init(store: StoreOf<HomeNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            TabView(selection: $store.selectedTab.sending(\.onTabSelection)) {
                Tab(.localized(.movies), systemImage: "movieclapper", value: TabType.movies) {
                    MoviesNavigator.ContentView(
                        store: store.scope(state: \.movies, action: \.movies)
                    )
                }
                
                Tab(.localized(.tvShows), systemImage: "tv", value: TabType.tvShows) {
                    Color.clear
                }
                
                Tab(.localized(.search), systemImage: "magnifyingglass", value: TabType.search, role: .search) {
                    SearchNavigator.ContentView(
                        store: store.scope(state: \.search, action: \.search)
                    )
                }
            }
            .environment(\.namespace, transitionNamespace)
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

