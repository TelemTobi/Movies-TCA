//
//  MovieListItem.swift
//  Presentation
//
//  Created by Telem Tobi on 04/12/2023.
//

import SwiftUI
import NukeUI
import Models

public struct MovieListItem: View {
    
    @State var movie: Movie
    @Binding var isLiked: Bool
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(movie: Movie, isLiked: Binding<Bool>) {
        self.movie = movie
        self._isLiked = isLiked
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let imageWidth = geometry.size.height / 1.6
            let imageHeight = geometry.size.height
            
            HStack(spacing: 10) {
                LazyImage(url: movie.thumbnailUrl) { state in
                    ZStack {
                        if let image = state.image {
                            image.resizable()
                        } else {
                            TmdbImagePlaceholder()
                        }
                    }
                    .animation(.smooth, value: state.image)
                }
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .cornerRadius(5)
                .shadow(radius: 3)
                .modify { view in
                    if #available(iOS 18.0, *), let namespace {
                        view.matchedTransitionSource(id: movie.id.description, in: namespace)
                    } else {
                        view
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(movie.title ?? "")
                            .lineLimit(2)
                            .font(.rounded(.title2))
                            .fontWeight(.bold)
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
