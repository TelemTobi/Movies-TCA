//
//  MovieNavigatorView.swift
//  Presentation
//
//  Created by Telem Tobi on 24/03/2024.
//

import SwiftUI
import ComposableArchitecture
import Models
import MovieDetailsFeature
import DesignSystem

public extension MovieNavigator {
    struct ContentView: View {
        
        @Bindable public var store: StoreOf<MovieNavigator>
        
        @Environment(\.namespace) private var namespace: Namespace.ID?
        @Environment(\.transitionSource) private var transitionSource: TransitionSource?
        
        private var transitionSourceId: String {
            let movieId = store.root.detailedMovie.movie.id
            return movieId.description + (transitionSource?.rawValue ?? "")
        }
        
        public init(store: StoreOf<MovieNavigator>) {
            self.store = store
        }
        
        public var body: some View {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path),
                root: {
                    MovieDetailsView(store: store.scope(state: \.root, action: \.root))
                },
                destination: { store in
                    switch store.case {
                    case let .relatedMovie(store):
                        MovieDetailsView(store: store)
                    }
                }
            )
            .zoomTransition(sourceID: transitionSourceId, in: namespace)
        }
    }
}

#Preview {
    MovieNavigator.ContentView(
        store: Store(
            initialState: MovieNavigator.State(detailedMovie: .mock),
            reducer: MovieNavigator.init
        )
    )
}
