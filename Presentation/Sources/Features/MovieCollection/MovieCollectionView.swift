//
//  MovieCollectionView.swift
//  Presentation
//
//  Created by Telem Tobi on 26/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Core
import Models
import DesignSystem

@ViewAction(for: MovieCollection.self)
public struct MovieCollectionView: View {
    
    public let store: StoreOf<MovieCollection>
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(store: StoreOf<MovieCollection>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            switch store.layout {
            case let .list(editable):
                listView(editable)
            case .grid:
                gridView()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .backgroundColor(.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.title)
    }
    
    private func listView(_ editable: Bool) -> some View {
        List {
            ForEach(Array((store.movieList.movies ?? []).enumerated()), id: \.offset) { index, movie in
                Button {
                    send(.onMovieTap(movie))
                } label: {
                    MovieListItem(
                        movie: movie,
                        index: store.indexed ? index + 1 : nil,
                        imageType: .backdrop
                    )
                }
                .buttonStyle(.plain)
                .frame(height: 70)
                .mediaContextMenu(
                    movie,
                    goToMedia: { send(.onMovieTap(movie)) },
                    shareMedia: {},
                    toggleWatchlist: { send(.onToggleWatchlist(movie)) }
                )
                .swipeActions(edge: .trailing) {
                    if editable {
                        Button(role: .destructive) {
                            send(.onToggleWatchlist(movie))
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: [.top, .bottom])
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                80 * Constants.ImageType.backdrop.ratio
            }
        }
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        let columns: [GridItem] = .init(
            repeating: GridItem(.flexible(), spacing: 20),
            count: 2
        )
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(store.movieList.movies ?? []) { movie in
                    Button {
                        send(.onMovieTap(movie))
                    } label: {
                        MovieGridItem(
                            movie: movie,
                            imageType: .backdrop
                        )
                    }
                    .matchedTransitionSource(id: movie.id.description, in: namespace)
                    .mediaContextMenu(
                        movie,
                        goToMedia: { send(.onMovieTap(movie)) },
                        shareMedia: {},
                        toggleWatchlist: { send(.onToggleWatchlist(movie)) }
                    )
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        MovieCollectionView(
            store: Store(
                initialState: MovieCollection.State(
                    movieList: .init(movies: [.mock, .mock]),
                    title: "Now Playing",
                    layout: .list(editable: true),
                    indexed: true
                ),
                reducer: { MovieCollection() }
            )
        )
    }
}
