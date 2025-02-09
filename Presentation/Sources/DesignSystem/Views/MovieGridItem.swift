//
//  MovieGridItem.swift
//  Presentation
//
//  Created by Telem Tobi on 09/02/2025.
//

import SwiftUI
import NukeUI
import Core
import Models

public struct MovieGridItem: View {
    
    let movie: Movie
    let imageType: Constants.ImageType
    
    private var imageUrl: URL? {
        switch imageType {
        case .poster: movie.posterThumbnailUrl
        case .backdrop: movie.backdropThumbnailUrl
        }
    }
    
    public init(movie: Movie, imageType: Constants.ImageType) {
        self.movie = movie
        self.imageType = imageType
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            LazyImage(url: imageUrl) { state in
                ZStack {
                    if let image = state.image {
                        image.resizable()
                    } else {
                        TmdbImagePlaceholder()
                    }
                }
                .animation(.smooth, value: state.image)
            }
            .aspectRatio(imageType.ratio, contentMode: .fill)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.ultraThinMaterial, lineWidth: 1)
            }
            
            Text(movie.title ?? .empty)
                .lineLimit(1)
                .font(.rounded(.callout, weight: .regular))
                .padding(.trailing)
                .padding(.leading, 4)
                .foregroundColor(.primary)
        }
    }
}
