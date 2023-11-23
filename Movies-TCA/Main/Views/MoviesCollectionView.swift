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
                EmptyView()
                    .navigationTitle(movie.title ?? .empty)
            } label: {
                VStack(alignment: .leading) {
                    WebImage(url: movie.thumbnailUrl)
                        .resizable()
                        .placeholder {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                                .frame(width: 130, height: 200)
                            
                            Image(systemName: "popcorn")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(.white)
                        }
                        .scaledToFill()
                        .frame(width: 130, height: 200)
                        .cornerRadius(10)
                        .transition(.fade)
                        .shadow(radius: 4)
                    
                    Text(movie.title ?? .empty)
                        .font(.subheadline)
                        .padding(.trailing)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .frame(width: 130)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    MoviesCollectionView(movies: [])
}
