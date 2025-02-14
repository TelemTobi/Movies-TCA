//
//  MovieGridItem.swift
//  Presentation
//
//  Created by Telem Tobi on 09/02/2025.
//

import SwiftUI
import Core
import Models

public struct MovieGridItem: View {
    
    public enum ExtendedDetails {
        case on(index: Int?)
        case off
    }
    
    let movie: Movie
    let imageType: Constants.ImageType
    let extendedDetails: ExtendedDetails
    
    private var imageUrl: URL? {
        switch imageType {
        case .poster: movie.posterThumbnailUrl
        case .backdrop: movie.backdropThumbnailUrl
        }
    }
    
    public init(movie: Movie, imageType: Constants.ImageType, extendedDetails: ExtendedDetails = .on(index: nil)) {
        self.movie = movie
        self.imageType = imageType
        self.extendedDetails = extendedDetails
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            LazyImage(url: imageUrl)
                .aspectRatio(imageType.ratio, contentMode: .fill)
                .clipShape(.rect(cornerRadius: 10))
                .adaptiveConstrast(shadow: .off)
            
            Group {
                if case .on = extendedDetails {
                    extendedDetailsView()
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
    private func extendedDetailsView() -> some View {
        let subtitle = [movie.releaseDate?.year.description, movie.genres?.first?.description]
            .compactMap { $0 }
            .joined(separator: .dotSeparator)
        
        HStack {
            if case let .on(index) = extendedDetails, let index {
                Text(index.description)
                    .font(.rounded(42, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            
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
        extendedDetails: .on(index: 3)
    )
}
