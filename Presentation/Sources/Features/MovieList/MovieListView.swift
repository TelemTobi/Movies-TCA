//
//  MovieListView.swift
//  Presentation
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Models
import DesignSystem

@ViewAction(for: MoviesListFeature.self)
public struct MovieListView: View {
    
    public let store: StoreOf<MoviesListFeature>
    
    public init(store: StoreOf<MoviesListFeature>) {
        self.store = store
    }
    
    public var body: some View {
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
        MovieListView(
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
