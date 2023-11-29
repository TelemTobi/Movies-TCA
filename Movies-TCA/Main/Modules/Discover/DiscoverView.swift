//
//  DiscoverView.swift
//  Movies-TCA
//
//  Created by Telem Tobi on 11/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct DiscoverView: View {
    
    let store: StoreOf<DiscoverFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    GeometryReader { geometry in
                        FeedView(
                            movies: viewStore.movies,
                            geometry: geometry
                        )
                        .environmentObject(viewStore)
                    }
                }
            }
            .navigationTitle("Discover")
            .animation(.easeInOut, value: viewStore.isLoading)
            .onFirstAppear {
                viewStore.send(.onFirstAppear)
            }
        }
    }
}

extension DiscoverView {
    
    private struct FeedView: View {

        @EnvironmentObject private var viewStore: ViewStoreOf<DiscoverFeature>
        
        let movies: [MoviesList.ListType: IdentifiedArrayOf<Movie>]
        let geometry: GeometryProxy
        
        var body: some View {
            List {
                ForEach(MoviesList.ListType.allCases, id: \.self) { listType in
                    if let movies = movies[listType] {
                        SectionView(
                            listType: listType,
                            movies: movies,
                            geometry: geometry
                        )
                        .environmentObject(viewStore)
                    }
                }
                .listRowInsets(.zero)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden, edges: .top)
            }
            .listStyle(.grouped)
            .scrollIndicators(.hidden)
        }
    }

    private struct SectionView: View {
        
        @EnvironmentObject private var viewStore: ViewStoreOf<DiscoverFeature>
        
        let listType: MoviesList.ListType
        let movies: IdentifiedArrayOf<Movie>
        let geometry: GeometryProxy
        
        var body: some View {
            Section {
                switch listType {
                case .nowPlaying:
                    MoviesPagerView(movies: movies) {
                        viewStore.send(.onMovieTap($0))
                    }
                    .frame(height: geometry.size.width / 1.6)
                    
                case .popular, .topRated, .upcoming:
                    MoviesCollectionView(movies: movies) {
                        viewStore.send(.onMovieTap($0))
                    }
                    .frame(height: geometry.size.width * 0.7)
                }
            } header: {
                if listType != .nowPlaying {
                    SectionHeader(
                        title: listType.title,
                        action: "See All",
                        onActionTap: {
                            viewStore.send(.onMoviesListTap(listType, movies))
                        }
                    )
                    .padding(.horizontal)
                    .textCase(.none)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DiscoverView(
            store: Store(
                initialState: DiscoverFeature.State(),
                reducer: { DiscoverFeature() }
            )
        )
    }
}
