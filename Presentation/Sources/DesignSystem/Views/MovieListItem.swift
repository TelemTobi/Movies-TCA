//
//  MovieListItem.swift
//  Presentation
//
//  Created by Telem Tobi on 04/12/2023.
//

import SwiftUI
import Core
import Models

public struct MovieListItem: View {
    
    @State var movie: Movie
    let index: Int?
    let imageType: Constants.ImageType
    
    @Environment(\.namespace) private var namespace: Namespace.ID?
    
    public init(movie: Movie, index: Int? = nil, imageType: Constants.ImageType) {
        self.movie = movie
        self.index = index
        self.imageType = imageType
    }
    
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 16) {
                imageView(geometry)
                    .adaptiveConstrast()
                    .matchedTransitionSource(id: movie.id.description, in: namespace)
                
                if let index {
                    Text(index.description)
                        .font(.rounded(.headline, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                
                contentView(geometry)
            }
        }
    }
    
    @ViewBuilder
    private func imageView(_ geometry: GeometryProxy) -> some View {
        let imageUrl = switch imageType {
        case .poster: movie.posterThumbnailUrl
        case .backdrop: movie.backdropThumbnailUrl
        }
        
        let imageHeight = geometry.size.height * 0.9
        let imageWidth = imageHeight * imageType.ratio
        
        LazyImage(url: imageUrl)
            .frame(width: imageWidth, height: imageHeight)
            .aspectRatio(imageType.ratio, contentMode: .fill)
            .cornerRadius(10)
    }
    
    @ViewBuilder
    private func contentView(_ geometry: GeometryProxy) -> some View {
        let titleFont: Font.TextStyle = switch geometry.size.height {
        case ..<100: .subheadline
        default: .title2
        }
        
        let subtitleFont: Font = switch geometry.size.height {
        case ..<100: .caption
        default: .callout
        }
        
        VStack(alignment: .leading, spacing: 5) {
            Text(movie.title ?? "")
                .lineLimit(2)
                .font(.rounded(titleFont, weight: .medium))
                .layoutPriority(1)
            
            
            if let genres = movie.genres?.prefix(2) {
                let joinedGenres = Array(genres)
                    .compactMap { $0.description }
                    .joined(separator: .dotSeparator)
                
                Text(joinedGenres)
                    .font(subtitleFont)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MovieListItem(
        movie: .mock,
        index: 3,
        imageType: .backdrop
    )
    .frame(height: 80)
}
