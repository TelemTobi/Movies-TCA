//
//  MovieDetailsView.swift
//  Presentation
//
//  Created by Telem Tobi on 24/11/2023.
//

import SwiftUI
import ComposableArchitecture
import Core
import Models
import DesignSystem

@ViewAction(for: MovieDetails.self)
public struct MovieDetailsView: View {
    
    @Bindable public var store: StoreOf<MovieDetails>
    
    @State var headerOffScreenPercentage: CGFloat = 0
    @State var isOverviewTruncated: Bool = false
    @State var isOverviewSheetPresented: Bool = false
    
    var navigationBarVisibilityThreshold: CGFloat = 0.83
    
    private var isHeaderShowing: Bool {
        headerOffScreenPercentage < navigationBarVisibilityThreshold
    }
    
    private var navigationTitleOpacity: CGFloat {
        headerOffScreenPercentage.percentageInside(range: navigationBarVisibilityThreshold...navigationBarVisibilityThreshold + 0.02)
    }
    
    public init(store: StoreOf<MovieDetails>) {
        self.store = store
    }
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                HeaderView(geometry: geometry)
                
                LazyVStack(spacing: 10) {
                    CastSection()
                    DirectorSection()
                    RelatedMoviesSection()
                    InformationSection()
                }
                .padding(.vertical, 5)
            }
            .listStyle(.plain)
            .backgroundColor(.background)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.snappy(duration: 0.5), value: store.detailedMovie)
        .toolbarBackground(isHeaderShowing ? .hidden : .visible, for: .navigationBar)
        .onFirstAppear { send(.onFirstAppear) }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(store.detailedMovie.movie.title ?? .empty)
                    .font(.rounded(.headline))
                    .multilineTextAlignment(.center)
                    .opacity(navigationTitleOpacity)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                CloseButton(
                    backgroundOpacity: 1 - navigationTitleOpacity,
                    action: { send(.onCloseButtonTap) }
                )
            }
        }
    }
    
    @ViewBuilder @MainActor
    private func CastSection() -> some View {
        Section {
            if let cast = store.detailedMovie.credits?.cast, cast.isNotEmpty {
                CastMembersView(
                    castMembers: cast,
                    didTapCastMember: { member in
                        // TODO: Cast member tap
                    }
                )
            }
        } header: {
            SectionHeader(title: .localized(.cast))
            .padding(.horizontal)
        }
        
        Divider()
            .padding(.vertical, 10)
            .padding(.horizontal)
    }
    
    @ViewBuilder @MainActor
    private func DirectorSection() -> some View {
        Section {
            if let director = store.detailedMovie.credits?.director {
                DirectorView(
                    director: director,
                    didTapDirector: { director in
                        // TODO: Director tap
                    }
                )
            }
        } header: {
            SectionHeader(title: .localized(.directedBy))
        }
        .padding(.horizontal)
        
        Divider()
            .padding(.vertical, 10)
            .padding(.horizontal)
    }
    
    @ViewBuilder @MainActor
    private func RelatedMoviesSection() -> some View {
        if let relatedMovies = store.detailedMovie.relatedMovies?.movies, relatedMovies.isNotEmpty {
            Section {
                MoviesRow(
                    movies: relatedMovies,
                    onMovieTap: { send(.onRelatedMovieTap($0)) },
                    toggleWatchlist: { send(.toggleWatchlist($0)) }
                )
            } header: {
                SectionHeader(title: .localized(.related))
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
            ForEach(store.detailedMovie.movie.infoDictionary.sorted(by: <), id: \.key) { key, value in
                VerticalKeyValueView(key: key, value: value)
                    .transition(.slideAndFade)
            }
        } header: {
            SectionHeader(title: .localized(.information))
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        MovieDetailsView(
            store: Store(
                initialState: MovieDetails.State(detailedMovie: .init(movie: .mock)),
                reducer: { MovieDetails() }
            )
        )
    }
}
