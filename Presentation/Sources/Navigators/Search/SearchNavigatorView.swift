//
//  SearchNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 20/03/2024.
//

import SwiftUI
import ComposableArchitecture
import SearchFeature
import PreferencesFeature
import MovieNavigator

public extension SearchNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<SearchNavigator>
        
        public init(store: StoreOf<SearchNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    SearchView(store: store.scope(state: \.root, action: \.root))
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
        private func PreferencesSheet(store: StoreOf<Preferences>) -> some View {
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
    SearchNavigator.ContentView(
        store: Store(
            initialState: SearchNavigator.State(),
            reducer: SearchNavigator.init
        )
    )
}

