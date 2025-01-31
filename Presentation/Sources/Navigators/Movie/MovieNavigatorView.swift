//
//  MovieNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 24/03/2024.
//

import SwiftUI
import ComposableArchitecture
import Models
import MovieFeature

public extension MovieNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<MovieNavigator>
        
        public init(store: StoreOf<MovieNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    MovieView(store: store.scope(state: \.root, action: \.root))
                },
                destination: { store in
                    switch store.case {
                    case let .relatedMovie(store):
                        MovieView(store: store)
                    }
                }
            )
        }
    }
}

//#Preview {
//    MovieNavigator.ContentView(
//        store: Store(
//            initialState: MovieNavigator.State(movieDetails: .mock),
//            reducer: MovieNavigator.init
//        )
//    )
//}


