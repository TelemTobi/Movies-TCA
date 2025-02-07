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
    let onMovieTap: (Movie) -> Void
    
    @State private var headerOffScreenOffset: CGFloat = 0
    private var navigationBarVisibilityThreshold: CGFloat = 0.83
    
    private var isHeaderShowing: Bool {
        headerOffScreenOffset < navigationBarVisibilityThreshold
    }
    
    private var navigationTitleOpacity: CGFloat {
        headerOffScreenOffset.percentageInside(range: navigationBarVisibilityThreshold...navigationBarVisibilityThreshold + 0.02)
    }
    
    fileprivate var headerOpacity: CGFloat {
        headerOffScreenOffset
            .percentageInside(range: 0.35...(navigationBarVisibilityThreshold + 0.01))
    }
    
    @Environment(\.namespace) private var namespace: Namespace.ID?

    public init(movies: IdentifiedArrayOf<Movie>, onMovieTap: @escaping (Movie) -> Void) {
        self.movies = movies
        self.onMovieTap = onMovieTap
    }
    
    public var body: some View {
        StretchyHeader($headerOffScreenOffset) {
            ParallaxPager(
                collection: movies.elements,
                content: { content(for: $0) },
                overlay: { overlay(for: $0) }
            )
        }
        .toolbar(content: toolbarContent)
        .toolbarBackground(isHeaderShowing ? .hidden : .visible, for: .navigationBar)
        .overlay {
            Color(resource: .background)
                .opacity(headerOpacity)
        }
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
        Button {
            onMovieTap(movie)
        } label: {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.4), .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(spacing: 12) {
                    Text(movie.title ?? "")
                        .font(.rounded(.title))
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
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
        .buttonStyle(.plain)
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.opacity(phase.isIdentity ? 1 : 0)
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(.localized(.discovery))
                .font(.rounded(.headline))
                .multilineTextAlignment(.center)
                .opacity(navigationTitleOpacity)
        }
    }
}

#Preview {
    let movies = try? TmdbMock.nowPlayingMovies
        .decode(into: MovieList.self, using: .tmdbDateDecodingStrategy)
        .movies ?? []
    
    MoviesPager(
        movies: .init(uniqueElements: movies ?? []),
        onMovieTap: { _ in }
    )
}
