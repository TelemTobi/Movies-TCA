//
//  MoviesListView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI
import Models

@ViewAction(for: MoviesListFeature.self)
struct MoviesListView: View {
    
    let store: StoreOf<MoviesListFeature>
    
    var body: some View {
        List {
            ForEach(store.movies) { movie in
                Button {
                    send(.onMovieTap(movie))
                } label: {
                    MovieListItem(
                        movie: movie,
                        isLiked: .init(
                            get: { store.watchlist.contains(movie) },
                            set: { _ in send(.onMovieLike(movie)) }
                        )
                    )
                }
                .buttonStyle(.plain)
            }
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
        }
        .listStyle(.grouped)
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.listType?.title ?? "")
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
