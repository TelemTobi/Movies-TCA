//
//  MoviesPagerView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 22/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct MoviesPagerView: View {
    
    let movies: IdentifiedArrayOf<Movie>
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(movies) { movie in
                        ItemView(movie: movie, geometry: geometry)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical)
                .padding(.horizontal, 16)
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    private struct ItemView: View {
        
        let movie: Movie
        let geometry: GeometryProxy
        
        var body: some View {
            GeometryReader { itemGeometry in
                let itemSize = itemGeometry.size
                let minX = itemGeometry.frame(in: .scrollView).minX * 0.5
                
                WebImage(url: movie.backdropUrl ?? movie.thumbnailUrl)
                    .resizable()
                    .transition(.fade(duration: 0.2))
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(1.2)
                    .offset(x: -minX)
                    .frame(width: itemSize.width, height: itemSize.height)
                    .overlay { OverlayView(for: movie) }
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(radius: 3)
            }
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
}

#Preview {
    MoviesPagerView(movies: [])
}
