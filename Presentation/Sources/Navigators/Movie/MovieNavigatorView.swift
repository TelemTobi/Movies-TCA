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
            .modify { view in
                if #available(iOS 18.0, *), let namespace {
                    let movieId = store.root.detailedMovie.movie.id
                    let sourceId = movieId.description + (transitionSource?.rawValue ?? "")
                    let _ = print(sourceId)
                    view.navigationTransition(.zoom(sourceID: sourceId, in: namespace))
                } else {
                    view
                }
            }
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
