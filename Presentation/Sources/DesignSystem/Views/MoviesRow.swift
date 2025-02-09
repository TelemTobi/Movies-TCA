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
    
    public init(movies: IdentifiedArrayOf<Movie>, listType: MovieListType? = nil, onMovieTap: @escaping (Movie) -> Void) {
        self.movies = movies
        self.listType = listType
        self.onMovieTap = onMovieTap
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(movies) { movie in
                        itemView(movie, geometry)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 16)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    private func itemView(_ movie: Movie, _ geometry: GeometryProxy) -> some View {
        Button {
            onMovieTap(movie)
        } label: {
            MovieGridItem(
                movie: movie,
                imageType: imageType
            )
        }
        .buttonStyle(.plain)
        .frame(width: (geometry.size.height - 40) * imageType.ratio)
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
    .frame(height: 280)
}
