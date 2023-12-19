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
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    HeaderView(
                        movie: viewStore.movieDetails.movie,
                        geometry: geometry,
                        navigationBarVisibilityThreshold,
                        $headerOffScreenPercentage
                    )
                    
                    LazyVStack(spacing: 10) {
                        CastSection()
                        Color.primary.colorInvert().frame(height: 800)
                    }
                }
                .environmentObject(viewStore)
                .listStyle(.plain)
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut, value: viewStore.movieDetails)
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
        }
    }
}

extension MovieView {
    
    private struct CastSection: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<MovieFeature>
        
        var body: some View {
            if let cast = viewStore.state.movieDetails.credits?.cast, cast.isNotEmpty {
                Section {
                    CastMembersView(castMembers: cast)
                } header: {
                    SectionHeader(title: "Cast", action: "See All") {
                        // TODO: See all tap
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                
            } else {
                EmptyView()
            }
        }
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
