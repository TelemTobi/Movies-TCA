//
//  MoviesListView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MoviesListView: View {
    
    let store: StoreOf<MoviesListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                ForEach(viewStore.movies) { movie in
                    Text(movie.title ?? .empty)
                }
            }
            .navigationTitle(viewStore.section.title)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MoviesListView(
            store: Store(
                initialState: MoviesListFeature.State(
                    section: .nowPlaying,
                    movies: [.mock, .mock]
                ),
                reducer: { MoviesListFeature() }
            )
        )
    }
}
