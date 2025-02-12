//
//  MoviesRow.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI
import NukeUI
import ComposableArchitecture
import Core
import Models

public struct MoviesRow: View {
    
    let movies: IdentifiedArrayOf<Movie>
    let listType: MovieListType?
    let onMovieTap: (Movie) -> Void
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    private var imageType: Constants.ImageType {
        listType?.imageType ?? .poster
    }
    
    private var itemWidth: CGFloat {
        switch listType {
        case .watchlist: 240
        case .popular, .topRated: 160
        case .upcoming, .nowPlaying, .none: 180
        }
    }
    
    public init(movies: IdentifiedArrayOf<Movie>, listType: MovieListType? = nil, onMovieTap: @escaping (Movie) -> Void) {
        self.movies = movies
        self.listType = listType
        self.onMovieTap = onMovieTap
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                    itemView(movie, index + 1)
                        .frame(width: itemWidth)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 16)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
    
    @ViewBuilder
    private func itemView(_ movie: Movie, _ index: Int) -> some View {
        let index = listType?.indexed == true ? index : nil
        
        Button {
            onMovieTap(movie)
        } label: {
            MovieGridItem(
                movie: movie,
                imageType: imageType,
                index: index
            )
        }
        .buttonStyle(.plain)
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
        .modify { view in
            if #available(iOS 18.0, *), let namespace {
                let sourceId = movie.id.description + (TransitionSource.collection.rawValue)
                view.matchedTransitionSource(id: sourceId, in: namespace)
            } else {
                view
            }
        }
    }
}

#Preview {
    MoviesRow(
        movies: .init(uniqueElements: MovieList.mock.movies ?? []),
        listType: .watchlist,
        onMovieTap: { _ in }
    )
    .frame(height: 150)
}
