//
//  WatchlistNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 24/03/2024.
//

import SwiftUI
import ComposableArchitecture
import WatchlistFeature
import MovieNavigator
import PreferencesFeature

public extension WatchlistNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<WatchlistNavigator>
        
        public init(store: StoreOf<WatchlistNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    WatchlistView(store: store.scope(state: \.root, action: \.root))
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
    WatchlistNavigator.ContentView(
        store: Store(
            initialState: WatchlistNavigator.State(),
            reducer: WatchlistNavigator.init
        )
    )
}


