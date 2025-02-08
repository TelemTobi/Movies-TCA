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
    
    public enum ContentType {
        case poster, backdrop
    }
    
    let type: ContentType
    let movies: IdentifiedArrayOf<Movie>
    let onMovieTap: (Movie) -> Void
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(type: ContentType, movies: IdentifiedArrayOf<Movie>, onMovieTap: @escaping (Movie) -> Void) {
        self.type = type
        self.movies = movies
        self.onMovieTap = onMovieTap
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
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
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    @ViewBuilder
    private func ItemView(_ movie: Movie, _ geometry: GeometryProxy) -> some View {
        let imageUrl = switch type {
        case .poster: movie.posterThumbnailUrl
        case .backdrop: movie.backdropThumbnailUrl
        }
        
        let imageRatio: CGFloat = switch type {
        case .poster: 14/21
        case .backdrop: 38/21
        }
            
        let itemHeight = geometry.size.height - 40
        let itemWidth = itemHeight * imageRatio
        
        VStack(alignment: .leading) {
            LazyImage(url: imageUrl) { state in
                ZStack {
                    if let image = state.image {
                        image.resizable()
                    } else {
                        TmdbImagePlaceholder()
                    }
                }
                .animation(.smooth, value: state.image)
            }
            .frame(width: itemWidth, height: itemHeight)
            .aspectRatio(imageRatio, contentMode: .fill)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.ultraThinMaterial, lineWidth: 1)
            }
            .modify { view in
                if #available(iOS 18.0, *), let namespace {
                    let sourceId = movie.id.description + (TransitionSource.collection.rawValue)
                    view.matchedTransitionSource(id: sourceId, in: namespace)
                } else {
                    view
                }
            }
            
            Text(movie.title ?? .empty)
                .lineLimit(1)
                .font(.rounded(.callout, weight: .regular))
                .padding(.trailing)
                .padding(.leading, 4)
                .foregroundColor(.primary)
        }
        .frame(width: itemWidth)
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.95)
        }
    }
}

#Preview {
    MoviesCollectionView(
        type: .poster,
        movies: .init(uniqueElements: MovieList.mock.movies ?? []),
        onMovieTap: { _ in }
    )
    .frame(height: 280)
}
