//
//  MovieView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct MovieView: View {
    
    let store: StoreOf<MovieFeature>
    
    @State private var headerOffScreenPercentage: CGFloat = 0
    @State private var headerTextColor: Color = .white
    @EnvironmentObject var statusBarConfigurator: StatusBarConfigurator
    
    private var navigationBarVisibilityThreshold: CGFloat = 0.85
    
    private var isHeaderShowing: Bool {
        headerOffScreenPercentage < navigationBarVisibilityThreshold
    }
    
    private var navigationTitleOpacity: CGFloat {
        headerOffScreenPercentage.percentageInside(range: navigationBarVisibilityThreshold...navigationBarVisibilityThreshold + 0.02)
    }
    
    init(store: StoreOf<MovieFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView(showsIndicators: false) {
                HeaderView(
                    navigationBarVisibilityThreshold: navigationBarVisibilityThreshold,
                    headerOffScreenPercentage: $headerOffScreenPercentage
                )
                
//                LazyVStack(spacing: 10) {
//                    Color.white.frame(height: 500)
//                }
            }
            .environmentObject(viewStore)
            .listStyle(.plain)
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut, value: viewStore.movieDetails)
//            .prepareStatusBarConfigurator(statusBarConfigurator)
            .toolbarBackground(isHeaderShowing ? .hidden : .visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewStore.movieDetails.movie.title ?? .empty)
                        .font(.rounded(.headline))
                        .opacity(navigationTitleOpacity)
                }
            }
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
            .onChange(of: isHeaderShowing) { _, _ in
                statusBarConfigurator.statusBarStyle = isHeaderShowing ? .lightContent : .default
            }
        }
    }
}

extension MovieView {
    
    private struct HeaderView: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<MovieFeature>
        
        let navigationBarVisibilityThreshold: CGFloat
        @Binding var headerOffScreenPercentage: CGFloat
        
        private var movie: Movie {
            viewStore.movieDetails.movie
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
        
        private var votesBulletPoints: String {
            [movie.voteAverageFormatted,
             movie.voteCountFormatted
            ].joined(separator: .dotSeparator)
        }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    StretchyHeader(
                        height: geometry.size.width * 1.4,
                        headerOffScreenOffset: $headerOffScreenPercentage,
                        header: {
                            WebImage(url: viewStore.movieDetails.movie.posterUrl)
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
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                        
                        Label(
                            title: {
                                Text(votesBulletPoints)
                                    .foregroundStyle(.white.opacity(0.5))
                                    .font(.caption2)
                                    .fontWeight(.heavy)
                            },
                            icon: {
                                Image("TMDBLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18)
                            }
                        )
                        .padding(.top, 10)
                    }
                    .padding()
                    .padding(.top, 50)
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
                }
                .overlay {
                    Color.primary.colorInvert()
                        .opacity(headerOpacity)
                }
            }
        }
    }
}

#Preview {
    MovieView(
        store: Store(
            initialState: MovieFeature.State(movieDetails: .init(movie: .mock)),
            reducer: { MovieFeature() }
        )
    )
}
