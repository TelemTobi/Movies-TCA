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
    @State private var isOverviewTruncated: Bool = false
    @State private var isOverviewSheetPresented: Bool = false
    
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
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                HeaderView(
                    movie: store.movieDetails.movie,
                    geometry: geometry,
                    navigationBarVisibilityThreshold,
                    $headerOffScreenPercentage,
                    onMovieLike: { store.send(.onLikeTap($0))}
                )
                
                LazyVStack(spacing: 10) {
                    CastSection()
                    DirectorSection()
                    RelatedMoviesSection()
                    InformationSection()
                }
                .padding(.vertical, 5)
            }
            .listStyle(.plain)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.snappy(duration: 0.5), value: store.movieDetails)
        .toolbarBackground(isHeaderShowing ? .hidden : .visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(store.movieDetails.movie.title ?? .empty)
                    .font(.rounded(.headline))
                    .multilineTextAlignment(.center)
                    .opacity(navigationTitleOpacity)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                CloseButton(
                    backgroundOpacity: 1 - navigationTitleOpacity,
                    action: { store.send(.onCloseButtonTap) }
                )
            }
        }
        .onFirstAppear {
            store.send(.onFirstAppear)
        }
    }
    
    @ViewBuilder @MainActor
    private func CastSection() -> some View {
        Section {
            if let cast = store.state.movieDetails.credits?.cast, cast.isNotEmpty {
                CastMembersView(
                    castMembers: cast,
                    didTapCastMember: { member in
                        // TODO: Cast member tap
                    }
                )
            }
        } header: {
            SectionHeader(title: "Cast", action: "See All") {
                // TODO: See All tap
            }
            .padding(.horizontal)
        }
        
        Divider()
            .padding(.vertical, 10)
            .padding(.horizontal)
    }
    
    @ViewBuilder @MainActor
    private func DirectorSection() -> some View {
        Section {
            if let director = store.state.movieDetails.credits?.director {
                DirectorView(
                    director: director,
                    didTapDirector: { director in
                        // TODO: Director tap
                    }
                )
            }
        } header: {
            SectionHeader(title: "Directed By")
        }
        .padding(.horizontal)
        
        Divider()
            .padding(.vertical, 10)
            .padding(.horizontal)
    }
    
    @ViewBuilder @MainActor
    private func RelatedMoviesSection() -> some View {
        if let relatedMovies = store.state.movieDetails.relatedMovies?.results, relatedMovies.isNotEmpty {
            Section {
                MoviesCollectionView(
                    movies: .init(uniqueElements: relatedMovies),
                    onMovieTap: { movie in
                        store.send(.onRelatedMovieTap(movie))
                    }
                )
                .frame(height: 280)
            } header: {
                SectionHeader(title: "Related")
                    .padding(.horizontal)
            }
            
            Divider()
                .padding(.vertical, 10)
                .padding(.horizontal)
            
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder @MainActor
    private func InformationSection() -> some View {
        Section {
            ForEach(store.movieDetails.movie.infoDictionary.sorted(by: <), id: \.key) { key, value in
                VerticalKeyValueView(key: key, value: value)
                    .transition(.slideAndFade)
            }
        } header: {
            SectionHeader(title: "Information")
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        MovieView(
            store: Store(
                initialState: MovieFeature.State(movieDetails: .init(movie: .mock)),
                reducer: { MovieFeature() }
            )
        )
    }
}
