//
//  DiscoveryNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 17/03/2024.
//

import SwiftUI
import ComposableArchitecture
import DiscoveryFeature
import MovieListFeature
import PreferencesFeature
import MovieNavigator

public extension DiscoveryNavigator {
    
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<DiscoveryNavigator>
        
        public init(store: StoreOf<DiscoveryNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    DiscoveryView(store: store.scope(state: \.root, action: \.root))
                        .fullScreenCover(
                            item: $store.scope(state: \.destination, action: \.destination),
                            content: { store in
                                switch store.case {
                                case let .movie(store):
                                    MovieNavigator.ContentView(store: store)
                                    
                                case let .preferences(store):
                                    PreferencesSheet(store: store)
                                }
                            }
                        )
                },
                destination: { store in
                    switch store.case {
                    case let .movieList(store):
                        MovieListView(store: store)
                    }
                }
            )
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
    DiscoveryNavigator.ContentView(
        store: Store(
            initialState: DiscoveryNavigator.State(),
            reducer: DiscoveryNavigator.init
        )
    )
}

