//
//  MoviesRow.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI
import NukeUI
import Core
import Models

public struct MoviesRow: View {
    
    let movies: [Movie]
    let imageType: Constants.ImageType
    let itemWidth: CGFloat
    let indexed: Bool
    let onMovieTap: (Movie) -> Void
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(movies: [Movie], imageType: Constants.ImageType = .poster, itemWidth: CGFloat = 160, indexed: Bool = false, onMovieTap: @escaping (Movie) -> Void) {
        self.movies = movies
        self.imageType = imageType
        self.itemWidth = itemWidth
        self.indexed = indexed
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
            .adaptiveShadow()
            .padding(.vertical)
            .padding(.horizontal, 16)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
    
    @ViewBuilder
    private func itemView(_ movie: Movie, _ index: Int) -> some View {
        let index = indexed ? index : nil
        let transitionSourceId = movie.id.description + TransitionSource.collection.rawValue
        
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
        .matchedTransitionSource(id: transitionSourceId, in: namespace)
    }
}

#Preview {
    MoviesRow(
        movies: MovieList.mock.movies ?? [],
        onMovieTap: { _ in }
    )
    .frame(height: 150)
}
