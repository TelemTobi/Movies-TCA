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
    let index: Int?
    
    private var imageUrl: URL? {
        switch imageType {
        case .poster: movie.posterThumbnailUrl
        case .backdrop: movie.backdropThumbnailUrl
        }
    }
    
    public init(movie: Movie, imageType: Constants.ImageType, index: Int? = nil) {
        self.movie = movie
        self.imageType = imageType
        self.index = index
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
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
            .clipShape(.rect(cornerRadius: 10))
            .adaptiveConstrast(shadow: .off)
            
            Group {
                if let index {
                    extendedDetailsView(index)
                } else {
                    Text(movie.title ?? .empty)
                        .lineLimit(1)
                        .font(.rounded(.callout, weight: .regular))
                        .padding(.trailing)
                        .padding(.leading, 4)
                        .foregroundColor(.primary)
                }
            }
            .layoutPriority(1)
        }
    }
    
    @ViewBuilder
    private func extendedDetailsView(_ index: Int) -> some View {
        let subtitle = [movie.releaseDate?.year.description, movie.genres?.first?.description]
            .compactMap { $0 }
            .joined(separator: .dotSeparator)
        
        HStack {
            Text(index.description)
                .font(.rounded(42, weight: .bold))
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading) {
                Text(movie.title ?? .empty)
                    .font(.rounded(.footnote, weight: .regular))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                if subtitle.isNotEmpty {
                    Text(subtitle)
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                }
            }
            .lineLimit(1)
            
            Spacer()
        }
    }
}

#Preview {
    MovieGridItem(
        movie: .mock,
        imageType: .backdrop,
        index: 2
    )
}
