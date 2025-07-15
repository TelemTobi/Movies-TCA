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
                                }
                            }
                        )
                        .sheet(
                            item: $store.scope(state: \.sheet, action: \.sheet),
                            content: { store in
                                switch store.case {
                                case let .preferences(store):
                                    PreferencesView(store: store)
                                        .presentationDetents([.medium])
                                }
                            }
                        )
                },
                destination: { store in
                    
                }
            )
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

