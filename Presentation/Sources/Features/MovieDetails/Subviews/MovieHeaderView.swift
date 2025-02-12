//
//  MovieHeaderView.swift
//  Presentation
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI
import NukeUI
import ComposableArchitecture
import Core
import DesignSystem

extension MovieDetailsView {
    
    @ViewBuilder
    func HeaderView(geometry: GeometryProxy) -> some View {
        let movie = store.detailedMovie.movie
        
        ZStack(alignment: .bottom) {
            StretchyHeader($headerOffScreenPercentage) {
                LazyImage(url: movie.posterUrl) { state in
                    if let image = state.image {
                        image.resizable()
                    } else {
                        LazyImage(url: movie.posterThumbnailUrl) { state in
                            if let image = state.image {
                                image.resizable()
                            }
                        }
                    }
                }
            }
            .aspectRatio(14/21, contentMode: .fill)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(movie.title ?? .empty)
                        .foregroundStyle(.white)
                        .font(.rounded(.title, weight: .bold))
                    
                    Spacer()
                    
                    LikeButton(
                        isLiked: .init(
                            get: { store.isLiked },
                            set: { _ in send(.onLikeTap) }
                        )
                    )
                    .padding(.vertical, 6)
                }
                
                Text(bulletPoints)
                    .foregroundStyle(.white.opacity(0.50))
                    .font(.caption.bold())
                    .padding(.top, 5)
                
                HStack(alignment: .bottom, spacing: 0) {
                    TruncableText(
                        movie.overview ?? .localized(.notAvailable),
                        lineLimit: 3,
                        truncationUpdate: { isTruncated in
                            isOverviewTruncated = isTruncated
                        }
                    )
                    .foregroundStyle(.white)
                    
                    Spacer(minLength: 0)
                    
                    if isOverviewTruncated {
                        Button(.localized(.more)) {
                            isOverviewSheetPresented = true
                        }
                    }
                }
                .padding(.top, 10)
                
                Label(
                    title: {
                        HStack(spacing: 2) {
                            Text(movie.voteAverageFormatted)
                            Text(String.dotSeparator)
                            Text(movie.voteCountFormatted)
                        }
                        .foregroundStyle(.white.opacity(0.5))
                        .font(.caption2)
                        .fontWeight(.heavy)
                    },
                    icon: {
                        Image(.tmdbLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18)
                    }
                )
                .padding(.top, 10)
            }
            .padding()
            .padding(.top, 50)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.35)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .light)
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .clear, location: 0.1),
                        .init(color: .white, location: 0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .sheet(isPresented: $isOverviewSheetPresented) {
                DynamicSheet(
                    title: movie.title ?? .localized(.notAvailable),
                    content: {
                        OverviewSheetContent()
                    }
                )
            }
        }
        .overlay {
            Color(.background)
                .opacity(headerOpacity)
        }
    }
    
    @ViewBuilder
    fileprivate func OverviewSheetContent() -> some View {
        VStack {
            if let tagline = store.detailedMovie.movie.tagline, tagline.isNotEmpty {
                Text("\"\(tagline)\"")
                    .font(.rounded(.title, weight: .bold))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding(.horizontal)
            }
            
            Text(store.detailedMovie.movie.overview ?? .localized(.notAvailable))
                .padding(.horizontal)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
    
    fileprivate var headerOpacity: CGFloat {
        headerOffScreenPercentage
            .percentageInside(range: 0.35...(navigationBarVisibilityThreshold + 0.01))
    }
    
    fileprivate var bulletPoints: String {
        [store.detailedMovie.movie.genres?.first?.description ?? .localized(.notAvailable),
         store.detailedMovie.movie.releaseDate?.year.description ?? .localized(.notAvailable),
         store.detailedMovie.movie.runtime?.durationInHoursAndMinutesShortFormat ?? .localized(.notAvailable)
        ].joined(separator: .dotSeparator)
    }
}
