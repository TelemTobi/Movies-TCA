//
//  WatchlistNavigatorView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/03/2024.
//

import SwiftUI
import ComposableArchitecture

extension WatchlistNavigator {
    
    struct ContentView: View {
        
        @Bindable var store: StoreOf<WatchlistNavigator>
        
        var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    WatchlistView(store: store.scope(state: \.root, action: \.root))
                        .fullScreenCover(
                            item: $store.scope(state: \.destination, action: \.destination),
                            content: { store in
                                switch store.case {
                                case let .movie(store):
                                    MovieSheet(store: store)
                                    
                                case let .preferences(store):
                                    PreferencesSheet(store: store)
                                }
                            }
                        )
                },
                destination: { store in
                    
                }
            )
        }
        
        @MainActor
        private func MovieSheet(store: StoreOf<MovieFeature>) -> some View {
            // TODO: MovieNavigator ⚠️
            NavigationStack {
//        NavigationStack(path: $store.scope(state: \.moviePath, action: \.moviePath)) {
                MovieView(store: store)
//        } destination: { store in
//            switch store.case {
//            case let .relatedMovie(store):
//                MovieView(store: store)
//            }
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
}

#Preview {
    WatchlistNavigator.ContentView(
        store: Store(
            initialState: WatchlistNavigator.State(),
            reducer: WatchlistNavigator.init
        )
    )
}


