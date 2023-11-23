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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(movies) { movie in
                        ItemView(movie: movie)
                            .transition(.slide.combined(with: .opacity))
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 16)
            }
        }
    }
    
    private struct ItemView: View {
        
        let movie: Movie
        
        var body: some View {
            
            NavigationLink {
                Color.clear
                    .navigationTitle(movie.title ?? .empty)
            } label: {
                VStack(alignment: .leading) {
                    WebImage(url: movie.thumbnailUrl)
                        .resizable()
                        .placeholder {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                                .frame(width: 140, height: 210)
                            
                            Image(systemName: "popcorn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(.white)
                        }
                        .scaledToFill()
                        .frame(width: 140, height: 210)
                        .cornerRadius(10)
                        .transition(.fade)
                        .shadow(radius: 4)
                    
                    Text(movie.title ?? .empty)
                        .lineLimit(1)
                        .font(.subheadline)
                        .padding(.trailing)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                }
                .frame(width: 140)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    MoviesCollectionView(movies: [])
}
