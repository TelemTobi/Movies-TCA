//
//  MoviesListView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct MoviesListView: View {
    
    let store: StoreOf<MoviesListFeature>
    
    var body: some View {
        List {
            ForEach(store.movies) { movie in
                MovieListButton(
                    movie: movie,
                    onMovieTap: { store.send(.onMovieTap($0)) },
                    onLikeTap: { store.send(.onMovieLike($0)) }
                )
                .padding()
                .frame(height: 200)
            }
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.listType?.title ?? "")
        .onFirstAppear {
            store.send(.onFirstAppear)
        }
    }
}

#Preview {
    NavigationStack {
        MoviesListView(
            store: Store(
                initialState: MoviesListFeature.State(
                    listType: .nowPlaying,
                    movies: [.mock, .mock]
                ),
                reducer: { MoviesListFeature() }
            )
        )
    }
}
