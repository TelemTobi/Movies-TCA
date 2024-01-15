//
//  MovieListItem.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 04/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListItem: View {
    
    @State var movie: Movie
    
    var body: some View {
        GeometryReader { geometry in
            let imageWidth = geometry.size.height / 1.6
            let imageHeight = geometry.size.height

            HStack(spacing: 10) {
                WebImage(url: movie.thumbnailUrl)
                    .resizable()
                    .placeholder {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray)
                            .frame(width: imageWidth, height: imageHeight)
                        
                        Image(systemName: "popcorn")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundColor(.white)
                    }
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .cornerRadius(5)
                    .transition(.fade)
                    .shadow(radius: 3)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(movie.title ?? "")
                            .lineLimit(2)
                            .font(.title2.weight(.bold))
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        LikeButton(
                            isLiked: $movie.isLiked,
                            color: .gray.opacity(0.3)
                        )
                        .padding(2)
                    }
                    
                    Text(movie.overview ?? "")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Spacer(minLength: 2)
                }
            }
        }
    }
}

#Preview {
    MovieListItem(movie: .mock)
        .previewLayout(.sizeThatFits)
}
