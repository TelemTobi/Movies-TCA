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
    
    public init(store: StoreOf<MovieCollection>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            switch store.collectionLayout {
            case .list:
                listView()
            case .grid:
                gridView()
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .backgroundColor(.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.listType?.title ?? "")
    }
    
    private func listView() -> some View {
        List {
            ForEach(Array(store.movies.enumerated()), id: \.offset) { index, movie in
                Button {
                    send(.onMovieTap(movie))
                } label: {
                    MovieListItem(
                        movie: movie,
                        index: index + 1,
                        imageType: .backdrop
                    )
                }
                .buttonStyle(.plain)
                .frame(height: 70)
            }
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .top)
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                80 * Constants.ImageType.backdrop.ratio
            }
        }
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        let columns: [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(store.movies) { movie in
                    MovieGridItem(
                        movie: movie,
                        imageType: .backdrop
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        MovieCollectionView(
            store: Store(
                initialState: MovieCollection.State(
                    listType: .nowPlaying,
                    movies: [.mock, .mock]
                ),
                reducer: { MovieCollection() }
            )
        )
    }
}
