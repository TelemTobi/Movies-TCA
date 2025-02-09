//
//  MovieListItem.swift
//  Presentation
//
//  Created by Telem Tobi on 04/12/2023.
//

import SwiftUI
import NukeUI
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
        .frame(width: imageWidth, height: imageHeight)
        .aspectRatio(imageType.ratio, contentMode: .fill)
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.ultraThinMaterial, lineWidth: 1)
        }
        .modify { view in
            if #available(iOS 18.0, *), let namespace {
                view.matchedTransitionSource(id: movie.id.description, in: namespace)
            } else {
                view
            }
        }
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
            
            Text(movie.overview ?? "")
                .font(subtitleFont)
                .foregroundStyle(.secondary)
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
