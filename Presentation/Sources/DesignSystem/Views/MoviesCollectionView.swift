//
//  MoviesCollectionView.swift
//  Presentation
//
//  Created by Telem Tobi on 23/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import ComposableArchitecture
import Models

public struct MoviesCollectionView: View {
    
    let movies: IdentifiedArrayOf<Movie>
    let onMovieTap: (Movie) -> Void
    var isMovieLiked: ((Movie) -> Binding<Bool>)? = nil
    
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
