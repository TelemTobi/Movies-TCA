//
//  MoviesPager.swift
//  Presentation
//
//  Created by Telem Tobi on 07/02/2025.
//

import SwiftUI
import IdentifiedCollections
import NukeUI
import Models
import TmdbApi

public struct MoviesPager: View {
    
    let movies: IdentifiedArrayOf<Movie>
    
    @Environment(\.namespace) private var namespace: Namespace.ID?

    public init(movies: IdentifiedArrayOf<Movie>) {
        self.movies = movies
    }
    
    public var body: some View {
        ParallaxPager(
            collection: movies.elements,
            content: { content(for: $0) },
            overlay: { overlay(for: $0) }
        )
    }
    
    @ViewBuilder
    private func content(for movie: Movie) -> some View {
        LazyImage(url: movie.posterUrl ?? movie.thumbnailUrl) { state in
            ZStack {
                if let image = state.image {
                    image.resizable()
                } else {
                    TmdbImagePlaceholder()
                }
            }
            .animation(.smooth, value: state.image)
        }
        .modify { view in
            if #available(iOS 18.0, *), let namespace {
                let sourceId = movie.id.description + (TransitionSource.pager.rawValue)
                view.matchedTransitionSource(id: sourceId, in: namespace)
            } else {
                view
            }
        }
    }
    
    private func overlay(for movie: Movie) -> some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.4), .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: 12) {
                Text(movie.title ?? "")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                
                if let overview = movie.overview {
                    Text(overview)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let movies = try? TmdbMock.nowPlayingMovies
        .decode(into: MovieList.self, using: .tmdbDateDecodingStrategy)
        .movies ?? []
    
    MoviesPager(
        movies: .init(uniqueElements: movies ?? [])
    )
}
