//
//  MoviesNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 17/03/2024.
//

import SwiftUI
import ComposableArchitecture
import MoviesHomepageFeature
import MovieCollectionFeature
import GenreDetailsFeature
import PreferencesFeature
import MovieNavigator
import DesignSystem

public extension MoviesNavigator {
    
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<MoviesNavigator>
        
        public init(store: StoreOf<MoviesNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    MoviesHomepageView(store: store.scope(state: \.root, action: \.root))
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
                        MovieCollectionView(store: store)
                        
                    case let .genreDetails(store):
                        GenreDetailsView(store: store)
                    }
                }
            )
            .environment(\.transitionSource, store.transitionSource)
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
    MoviesNavigator.ContentView(
        store: Store(
            initialState: MoviesNavigator.State(),
            reducer: MoviesNavigator.init
        )
    )
}

