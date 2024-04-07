//
//  MoviesCollectionView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import ComposableArchitecture

struct MoviesCollectionView: View {
    
    let movies: IdentifiedArrayOf<Movie>
    let onMovieTap: MovieClosure
    var onLikeTap: MovieClosure? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(movies) { movie in
                        ItemView(
                            movie: movie,
                            geometry: geometry,
                            onMovieTap: onMovieTap,
                            onLikeTap: onLikeTap
                        )
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 16)
            }
        }
    }
    
    private struct ItemView: View {
        
        let movie: Movie
        let geometry: GeometryProxy
        let onMovieTap: MovieClosure
        var onLikeTap: MovieClosure? = nil
        
        var body: some View {
            let itemWidth = geometry.size.height / 1.8
            let itemHeight = geometry.size.height - 40
            
            Button {
                onMovieTap(movie)
            } label: {
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing) {
                        WebImage(url: movie.thumbnailUrl)
                            .resizable()
                            .placeholder {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray)
                                    .frame(width: itemWidth, height: itemHeight)
                                
                                Image(systemName: "popcorn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .foregroundColor(.white)
                            }
                            .scaledToFill()
                            .frame(width: itemWidth, height: itemHeight)
                            .cornerRadius(10)
                            .transition(.fade)
                            .shadow(radius: 3)
                        
                        if let onLikeTap {
                            LikeButton(
                                isLiked: .init(
                                    get: { movie.isLiked },
                                    set: { _ in onLikeTap(movie) } // TODO
                                )
                            )
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
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    MoviesCollectionView(
        movies: IdentifiedArray(uniqueElements: MoviesList.mock.results ?? []),
        onMovieTap: { _ in },
        onLikeTap: { _ in }
    )
    .frame(height: 280)
}
