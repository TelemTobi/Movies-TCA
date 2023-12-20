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
    let onMovieTap: (Movie) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(movies) { movie in
                        Button(
                            action: { onMovieTap(movie) },
                            label: { ItemView(movie: movie, geometry: geometry) }
                        )
                        .buttonStyle(.plain)
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
        
        var body: some View {
            let itemWidth = geometry.size.height / 1.8
            let itemHeight = geometry.size.height - 40
            
            VStack(alignment: .leading) {
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
}

#Preview {
    MoviesCollectionView(movies: [.mock, .mock, .mock], onMovieTap: { _ in })
}
