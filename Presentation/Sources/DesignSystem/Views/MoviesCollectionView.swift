//
//  MoviesCollectionView.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI
import NukeUI
import ComposableArchitecture
import Models

public struct MoviesCollectionView: View {
    
    let movies: IdentifiedArrayOf<Movie>
    let onMovieTap: (Movie) -> Void
    var isMovieLiked: ((Movie) -> Binding<Bool>)? = nil
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(movies: IdentifiedArrayOf<Movie>, onMovieTap: @escaping (Movie) -> Void, isMovieLiked: ((Movie) -> Binding<Bool>)? = nil) {
        self.movies = movies
        self.onMovieTap = onMovieTap
        self.isMovieLiked = isMovieLiked
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(movies) { movie in
                        Button {
                            onMovieTap(movie)
                        } label: {
                            ItemView(movie, geometry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 16)
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private func ItemView(_ movie: Movie, _ geometry: GeometryProxy) -> some View {
        let itemWidth = geometry.size.height / 1.8
        let itemHeight = geometry.size.height - 40
            
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                LazyImage(url: movie.thumbnailUrl) { state in
                    ZStack {
                        if let image = state.image {
                            image.resizable()
                        } else {
                            TmdbImagePlaceholder()
                        }
                    }
                    .animation(.smooth, value: state.image)
                }
                .scaledToFill()
                .frame(width: itemWidth, height: itemHeight)
                .cornerRadius(10)
                .shadow(radius: 3)
                .modify { view in
                    if #available(iOS 18.0, *), let namespace {
                        view.matchedTransitionSource(id: movie.id, in: namespace)
                    } else {
                        view
                    }
                }
                
                if let isMovieLiked {
                    LikeButton(isLiked: isMovieLiked(movie))
                        .padding(10)
                }
            }
            
            Text(movie.title ?? .empty)
                .lineLimit(1)
                .font(.subheadline)
                .padding(.trailing)
                .padding(.leading, 4)
                .foregroundColor(.primary)
        }
        .frame(width: itemWidth)
    }
}

#Preview {
    MoviesCollectionView(
        movies: IdentifiedArray(uniqueElements: MovieList.mock.movies ?? []),
        onMovieTap: { _ in },
        isMovieLiked: { _ in .constant(true) }
    )
    .frame(height: 280)
}
