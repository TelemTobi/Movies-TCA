//
//  MovieListItem.swift
//  Presentation
//
//  Created by Telem Tobi on 04/12/2023.
//

import SwiftUI
import Kingfisher
import Models

public struct MovieListItem: View {
    
    @State var movie: Movie
    @Binding var isLiked: Bool
    
    public init(movie: Movie, isLiked: Binding<Bool>) {
        self.movie = movie
        self._isLiked = isLiked
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let imageWidth = geometry.size.height / 1.6
            let imageHeight = geometry.size.height
            
            HStack(spacing: 10) {
                KFImage(movie.thumbnailUrl)
                    .resizable()
                    .placeholder { ImagePlaceholder() }
                    .fade(duration: 0.5)
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageHeight)
                    .cornerRadius(5)
                    .shadow(radius: 3)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(movie.title ?? "")
                            .lineLimit(2)
                            .font(.title2.weight(.bold))
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        LikeButton(
                            isLiked: $isLiked,
                            outlineColor: .gray.opacity(0.3)
                        )
                        .padding(.vertical, 2)
                    }
                    
                    Text(movie.overview ?? "")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Spacer(minLength: 2)
                }
            }
        }
        .padding()
        .frame(height: 200)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieListItem(
        movie: .mock,
        isLiked: .constant(false)
    )
}
