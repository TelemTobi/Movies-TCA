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
    
    @State private var currentItem: Movie?
    @State private var scrollOffset: CGFloat = 0
    @State private var offScreenOffset: CGFloat = 0

    private var navigationBarVisibilityThreshold: CGFloat = 0.8

    private var isHeaderShowing: Bool {
        offScreenOffset < navigationBarVisibilityThreshold
    }
    
    private var navigationTitleOpacity: CGFloat {
        offScreenOffset.percentageInside(range: navigationBarVisibilityThreshold...navigationBarVisibilityThreshold + 0.02)
    }
    
    private var headerOpacity: CGFloat {
        offScreenOffset.percentageInside(range: 0.35...(navigationBarVisibilityThreshold + 0.01))
    }
    
    @Environment(\.namespace) private var namespace: Namespace.ID?

    public init(movies: IdentifiedArrayOf<Movie>, onMovieTap: @escaping (Movie) -> Void) {
        self.movies = movies
        self.onMovieTap = onMovieTap
    }
    
    public var body: some View {
        GeometryReader { geo in
            ParallaxPager(
                collection: movies.elements,
                content: {
                    content(for: $0)
                        .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                        .offset(y: max(scrollOffset / 1.25, 0))
                        .clipShape(.bottomClip(height: geo.size.height))
                },
                overlay: { overlay(for: $0) }
            )
            .scaleEffect(max(1 - (scrollOffset / geo.frame(in: .global).height), 1), anchor: .bottom)
            .didScroll { offset in
                scrollOffset = offset
                let offScreenPercentage = offset / geo.size.height
                self.offScreenOffset = offScreenPercentage.clamped(to: 0...1)
            }
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
        LazyImage(url: movie.posterUrl ?? movie.posterThumbnailUrl) { state in
            ZStack {
                if let image = state.image {
                    image.resizable()
                } else {
                    TmdbImagePlaceholder()
                }
            }
            .animation(.smooth, value: state.image)
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
    
    ScrollView {
        MoviesPager(
            movies: .init(uniqueElements: movies ?? []),
            onMovieTap: { _ in }
        )
        .aspectRatio(14/21, contentMode: .fill)
    }
    .ignoresSafeArea(edges: .top)
}
