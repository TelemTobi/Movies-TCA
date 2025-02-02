//
//  MoviesPagerView.swift
//  Presentation
//
//  Created by Telem Tobi on 22/11/2023.
//

import SwiftUI
import ComposableArchitecture
import NukeUI
import Models

public struct MoviesPagerView: View {
    
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
                HStack(spacing: 0) {
                    ForEach(movies) { movie in
                        Button {
                            onMovieTap(movie)
                        } label: {
                            ItemView(movie, geometry)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical)
                .padding(.horizontal, 16)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    @MainActor
    @ViewBuilder
    private func ItemView(_ movie: Movie, _ geometry: GeometryProxy) -> some View {
        GeometryReader { itemGeometry in
            let itemSize = itemGeometry.size
            let minX = itemGeometry.frame(in: .scrollView).minX * 0.5
            
            ZStack(alignment: .topTrailing) {
                LazyImage(url: movie.backdropUrl ?? movie.thumbnailUrl) { state in
                    ZStack {
                        if let image = state.image {
                            image.resizable()
                        } else {
                            TmdbImagePlaceholder()
                        }
                    }
                    .animation(.smooth, value: state.image)
                }
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.2)
                .offset(x: -minX)
                .frame(width: itemSize.width, height: itemSize.height)
                .overlay { OverlayView(for: movie) }
                .clipShape(.rect(cornerRadius: 10))
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
        }
        .contentShape(Rectangle())
        .frame(width: geometry.size.width - 32)
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
    }
    
    private func OverlayView(for movie: Movie) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.4), .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading) {
                Text(movie.title ?? "")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                
                if let overview = movie.overview {
                    Text(overview)
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(1)
                }
            }
            .padding()
        }
    }
}

#Preview {
    MoviesPagerView(
        movies: .init(uniqueElements: MovieList.mock.movies ?? []),
        onMovieTap: { _ in }
    )
    .frame(height: 260)
}
