//
//  MovieHeaderView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 19/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

extension MovieView {
    
    struct HeaderView: View {
        
        let movie: Movie
        @Binding var headerOffScreenPercentage: CGFloat
        @State private var isSheetPresented: Bool = false
        
        let geometry: GeometryProxy
        let navigationBarVisibilityThreshold: CGFloat
        
        init(movie: Movie, geometry: GeometryProxy, _ navigationBarVisibilityThreshold: CGFloat, _ headerOffScreenPercentage: Binding<CGFloat>) {
            self.movie = movie
            self.geometry = geometry
            self.navigationBarVisibilityThreshold = navigationBarVisibilityThreshold
            self._headerOffScreenPercentage = headerOffScreenPercentage
        }
        
        private var headerOpacity: CGFloat {
            headerOffScreenPercentage
                .percentageInside(range: 0.35...(navigationBarVisibilityThreshold + 0.01))
        }
        
        private var bulletPoints: String {
            [movie.genres?.first?.name ?? .notAvailable,
             movie.releaseDate?.year.description ?? .notAvailable,
             movie.runtime?.durationInHoursAndMinutesShortFormat ?? .notAvailable
            ].joined(separator: .dotSeparator)
        }
        
        var body: some View {
            ZStack(alignment: .bottom) {
                StretchyHeader(
                    height: geometry.size.width * 1.5,
                    headerOffScreenOffset: $headerOffScreenPercentage,
                    header: {
                        WebImage(url: movie.posterUrl)
                            .resizable()
                            .scaledToFill()
                    }
                )
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(movie.title ?? .empty)
                        .foregroundStyle(.white)
                        .font(.rounded(.title, weight: .bold))
                    
                    Text(bulletPoints)
                        .foregroundStyle(.white.opacity(0.50))
                        .font(.caption.bold())
                        .padding(.top, 5)
                    
                    Text(movie.overview ?? .notAvailable)
                        .lineLimit(3)
                        .foregroundStyle(.white)
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
                .onTapGesture { isSheetPresented = true }
                .sheet(isPresented: $isSheetPresented) {
                    DynamicSheet(
                        title: movie.title ?? .notAvailable,
                        content: {
                            VStack {
                                if let tagline = movie.tagline, tagline.isNotEmpty {
                                    Text("\"\(tagline)\"")
                                        .font(.rounded(.title, weight: .bold))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 10)
                                        .padding(.horizontal)
                                }
                                
                                Text(movie.overview ?? .notAvailable)
                                    .padding(.horizontal)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    )
                }
            }
            .overlay {
                Color.primary.colorInvert()
                    .opacity(headerOpacity)
            }
        }
    }
}

#Preview {
    @State var headerOffScreenPercentage: CGFloat = 0
    
    return ScrollView {
        GeometryReader { geometry in
            MovieView.HeaderView(
                movie: .mock,
                geometry: geometry,
                0.85,
                $headerOffScreenPercentage
            )
        }
    }
}
